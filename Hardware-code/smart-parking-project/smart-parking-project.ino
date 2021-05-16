#include <Arduino.h>
#include <Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <NfcAdapter.h>
#include <ESP8266WiFi.h>
#include <LiquidCrystal_I2C.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>

StaticJsonDocument<200> doc;

PN532_I2C pn532_i2c(Wire);
NfcAdapter nfc = NfcAdapter(pn532_i2c);

String ip_address = "192.168.0.106:8080";

#define IR_SENSOR 14

#define BUZZER 0

#define WIFI_SSID "ASV_HOME"

#define WIFI_PASSWORD "87554321"

String SLOT_NAME = "Slot 1";
String slot_name = "Slot%201";
LiquidCrystal_I2C lcd(0x27, 16, 2);
WiFiClient client;
HTTPClient http;

const long interval = 3000;
unsigned long previousMillis = 0;        // will store last time LED was updated

struct FLAGS {
  bool is_slot_booked = false;
  bool is_slot_occupied = false;
  bool is_billing_running = false;
}flags;

// THESE ARE THE ERROR CONSTANTS
String FOUND_ERROR = "FOUND_ERROR";
String UNABLE_TO_CONNECT = "UNABLE_TO_CONNECT";

// JSON FLAGS ARE MENTIONED BELOW
String OK_ = "OK";
String BILLING_IS_RUNNING = "BILLING_IS_RUNNING";
String STARTED_TIMER = "STARTED_TIMER";
String MISMATCHED_UUID = "MISMATCHED_UUID";
String BILL_UPDATED = "BILL_UPDATED";
String BILL_NOT_STARTED = "BILL_NOT_STARTED";
String CHECKOUT_DONE = "CHECKOUT_DONE";

void setup() {
  // initialize the LCD
  lcd.begin();
  // Turn on the blacklight and print a message.
  lcd.setCursor(0,0);
  lcd.print("PARKING SYS WITH");
  lcd.setCursor(0,1);
  lcd.print("EWALLET FACILITY");
  Serial.begin(115200);
  
  Serial.println("NDEF Reader");
  nfc.begin();
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  lcd.clear();
  
  pinMode(IR_SENSOR, INPUT);
  pinMode(BUZZER, OUTPUT);


  // TRY TO CHECK OUT IF THE BILLING IS ACTUALLY RUNNING OR NOT
  String process_update_request = "http://"+ip_address+"/update_bill?slotname="+slot_name;
  String resp = request(process_update_request);

  if ((resp!=FOUND_ERROR)||(resp!=UNABLE_TO_CONNECT)){
          // THEN IT MEANS, THAT THE HTTP STATUS IS 200, OK
          
          DeserializationError error = deserializeJson(doc, resp);
          
          // Test if parsing succeeds.
          if (error){
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
          }
          
          String status_ = doc["status"];
          
          if (status_ == OK_){
            
            String message_ = doc["message"];
            
            if(message_==BILL_UPDATED){
              Serial.println("PROCESS HAS ALREADY BEGUN");
              flags.is_slot_occupied = true;
              flags.is_billing_running = true;
              String bill = doc["bill"];
              String time_spent = doc["minutes_spent"];
               
            }else if(message_==BILL_NOT_STARTED){
              Serial.println("BILLING HAS NOT YET STARTED");
              flags.is_slot_occupied = false;
              flags.is_billing_running = false;
            }
          }else{
            // PROCESS IS NOT THERE
            flags.is_slot_occupied = false;
            flags.is_billing_running = false;
          }
  }
}


void loop() {
  // NO CAR IS PLACED, THEN SHOW THEM WELCOME SCREEN
  lcd.setCursor(0,0);
  lcd.println("    WELCOME     ");
  lcd.setCursor(0,1);
  lcd.println("BOOK, SCAN & PAY");
  
  if(digitalRead(IR_SENSOR)){
    // IF, THE CAR IS DETECTED THEN, ASK FOR USER TO SCAN
    lcd.setCursor(0,0);
    lcd.println(" CAR IS PARKED  ");
    lcd.setCursor(0,1);
    lcd.println(" SCAN THE CARD  ");
    while(digitalRead(IR_SENSOR)){
      lcd.setCursor(0,0);
      lcd.println(" CAR IS PARKED  ");
      lcd.setCursor(0,1);
      lcd.println(" SCAN THE CARD  ");
      String empty = "";
      String nfc_data = "";
      nfc_data = scan_nfc_card();
      if (nfc_data != empty){
        // IF THE CARD IS SCANNED, AND THE DATA IS OBTAINED
        Serial.println("THE SCANNED CARD HAS "+nfc_data);
        if(flags.is_billing_running!=true) {
        // IF THE BILLING PROCESS IS NOT STARTED THEN, DO THIS
        String start_request = "http://"+ip_address+"/check_slot_and_start?uuid="+nfc_data+"&slotname="+slot_name;
        String resp = request(start_request);
        lcd.setCursor(0,0);
        lcd.println("CARD IS SCANNED ");

        if ((resp!=FOUND_ERROR)||(resp!=UNABLE_TO_CONNECT)){
          // THEN IT MEANS, THAT THE HTTP STATUS IS 200, OK
          DeserializationError error = deserializeJson(doc, resp);
          // Test if parsing succeeds.
          if (error){
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
          }
          String status_ = doc["status"];
          if (status_ == OK_){
            String message_ = doc["message"];
            if(message_==STARTED_TIMER){
              Serial.println("INITIATED THE TIMER SUCCESSFULLY");
              lcd.setCursor(0,0);
              lcd.println("CARD IS SCANNED ");
              lcd.setCursor(0,1);
              lcd.println("BILLING STARTED");
              flags.is_slot_occupied = true;
              flags.is_billing_running = true;
            }else if(message_==BILLING_IS_RUNNING){
              Serial.println("BILLING IS RUNNING");
              lcd.setCursor(0,0);
              lcd.println("CARD IS SCANNED ");
              lcd.setCursor(0,1);
              lcd.println("BILL IS RUNNING");
              flags.is_slot_occupied = true;
              flags.is_billing_running = true;
            }else if(message_==MISMATCHED_UUID){
              lcd.setCursor(0,0);
              lcd.println("CARD IS SCANNED ");
              lcd.setCursor(0,1);
              lcd.println(" CARD MISMATCH ");
              Serial.print("THE ID IS MISMATCHED, TRY AGAIN");
              flags.is_slot_occupied = false;
              flags.is_billing_running = false;
            }
          }else{
            Serial.println("HEY, THE SLOT IS NOT BOOKED ONLY");
            lcd.setCursor(0,0);
            lcd.println("CARD IS SCANNED ");
            lcd.setCursor(0,1);
            lcd.println("CAR NOT BOOKED ");
          }
        }
        }else{
          // DO THE FINAL PAYMENT REQUEST AS, BILLING IS ALREDY HAPPENING
          Serial.println("DO YOU WISH TO CHECKOUT NOW ONLY");
          String checkout_request = "http://"+ip_address+"/check_and_debit_ewallet?uuid="+nfc_data+"&slotname="+slot_name;
          String resp = request(checkout_request);
          if ((resp!=FOUND_ERROR)||(resp!=UNABLE_TO_CONNECT)){
          // THEN IT MEANS, THAT THE HTTP STATUS IS 200, OK
          DeserializationError error = deserializeJson(doc, resp);
          // Test if parsing succeeds.
          if (error){
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
          }
          String status_ = doc["status"];
          if (status_ == OK_){
            String message_ = doc["message"];
            if(message_==CHECKOUT_DONE){
              Serial.println("SUCCESSFULLY PAID THE TRANSACTION");
              lcd.setCursor(0,0);
              lcd.println("CARD IS SCANNED ");
              lcd.setCursor(0,1);
              lcd.println("CHECKOUT IS DONE");
              flags.is_slot_occupied = false;
              flags.is_billing_running = false;
            }else if(message_==MISMATCHED_UUID){
              lcd.setCursor(0,0);
              lcd.println("CARD IS SCANNED ");
              lcd.setCursor(0,1);
              lcd.println("MISMATCH IN CARD");
              Serial.print("THE ID IS MISMATCHED, TRY AGAIN TO STOP THE TIMER, IF YOU ARE NEW USER, TRY OTHER SLOTS");
              flags.is_slot_occupied = true;
              flags.is_billing_running = true;
            }
          }else{
            Serial.println("HEY, THE SLOT IS NOT BOOKED ONLY");
            lcd.setCursor(0,0);
            lcd.println("CARD IS SCANNED ");
            lcd.setCursor(0,1);
            lcd.println("CAR NOT BOOKED ");
          }
        }
        }
        delay(3000);
      }

      unsigned long currentMillis = millis();
      if(currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis;
        if(flags.is_billing_running){
          String process_update_request = "http://"+ip_address+"/update_bill?slotname="+slot_name;
          String resp = request(process_update_request);
          Serial.println(resp);
            if ((resp!=FOUND_ERROR)||(resp!=UNABLE_TO_CONNECT)){
          // THEN IT MEANS, THAT THE HTTP STATUS IS 200, OK
          DeserializationError error = deserializeJson(doc, resp);
          // Test if parsing succeeds.
          if (error){
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            return;
          }
          String status_ = doc["status"];
          if (status_ == OK_){
            String message_ = doc["message"];
            
            if(message_==BILL_UPDATED){
              Serial.println("PROCESS HAS ALREADY BEGUN");
              flags.is_slot_occupied = true;
              flags.is_billing_running = true;
              String bill = doc["bill"];
              String time_spent = doc["minutes_spent"];
              lcd.clear();
              String firstRow = "SPENT:"+time_spent+" MINS";
              String secondRow = "BILL: INR "+bill;
              lcd.setCursor(0,0);
              lcd.println(firstRow);
              lcd.setCursor(0,1);
              lcd.println(secondRow);
            
            }else if(message_==BILL_NOT_STARTED){
              Serial.println("BILLING HAS NOT YET STARTED");
              flags.is_slot_occupied = false;
              flags.is_billing_running = false;
            }
            
          }else{
            // PROCESS IS NOT THERE
            flags.is_slot_occupied = false;
            flags.is_billing_running = false;
            
          }
          
          }
          
        }
        
      }
      
    }
  }
  
}

String request(String url) {
  if (http.begin(client, url)) {
      int httpCode = http.GET();
      if (httpCode > 0) {
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = http.getString();
          //Serial.println(payload);
          return payload;
        }
      } else {
        //Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
        return "FOUND_ERROR";
      }
      http.end();
    } else {
      //Serial.printf("[HTTP} Unable to connect\n");
      return "UNABLE_TO_CONNECT";
    }
    
}

String scan_nfc_card(){
  String payloadAsString = "";
  if (nfc.tagPresent()){
    NfcTag tag = nfc.read();
    if (tag.hasNdefMessage()) {
      NdefMessage message = tag.getNdefMessage();
      Serial.print(" NDEF Record");
      if (message.getRecordCount() != 1) {
        Serial.print("s");
      }
      Serial.println(".");

      // cycle through the records, printing some info from each
      int recordCount = message.getRecordCount();
      for (int i = 0; i < recordCount; i++) {
        NdefRecord record = message.getRecord(i);

        int payloadLength = record.getPayloadLength();
        byte payload[payloadLength];
        record.getPayload(payload);
        
        for (int c = 1; c < payloadLength; c++) {
          payloadAsString += (char)payload[c];
        }
        Serial.print("  Payload (as String): ");
        Serial.println(payloadAsString);
        
        String uid = record.getId();
        if (uid != "") {
          Serial.print("  ID: ");Serial.println(uid);
        }
        
      }
    }
  }
  return payloadAsString;
}

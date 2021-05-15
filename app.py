from passlib.hash import sha256_crypt
from flask import *
import mysql.connector
from datetime import datetime
import json


DB_SERVER_NAME = "remotemysql.com"
USERNAME = "ks0Mw22MM6"
PASSWORD = "4C9FLMo7VK"
DATABASE = "ks0Mw22MM6"

IP_ADDRESS = "0.0.0.0"
PORT = 8080

mydb = mysql.connector.connect(
  host = DB_SERVER_NAME,
  user = USERNAME,
  password = PASSWORD,
  database = DATABASE
)

mycursor = mydb.cursor()

app = Flask(__name__)

app.secret_key = "THIS-IS-SECRET-KEY"

@app.route("/")
def root_index():
    sql = "SELECT * FROM `smart-parking-bank-account-with-transactions` ORDER BY slno DESC"
    global mycursor, mydb
    mycursor.execute(sql)
    result = mycursor.fetchall()
    mydb.commit()
    print(result)
    return render_template("transaction-details.html", result = result)

"""
@app.route("/stream_current_slot")
def stream_current_slot():
    uuid = session["uuid"]
    def eventStream():
        while True:
            global mycursor, mydb
            sql = "SELECT slotname, orderedtime, startdatetime, currentbill FROM slot_database_details WHERE occupieduuid = %s"
            val = (uuid,)
            mycursor.execute(sql, val)
            resp = mycursor.fetchone()
            mydb.commit()
            if resp != None:
                data = {}
                data["slotname"] = resp[0]
                data["orderedtime"] = resp[1]
                data["starttime"] = resp[2]
                now = datetime.now()
                dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
                data["currenttime"] = dt_string
                data["currentbill"] = resp[3]
                sql = "SELECT current_balance FROM user_database WHERE uuid = %s"
                val = (uuid,)
                mycursor.execute(sql, val)
                resp = mycursor.fetchone()
                mydb.commit()
                data["balance"] = resp[0]
                # wait for source data to be available, then push it
                myjson = json.dumps(data)
                yield 'data: '+str(myjson)+"\n\n"
            else:
                return None
    return Response(eventStream(), mimetype="text/event-stream")

"""
@app.route("/cancel-booking")
def cancel_booking():
    if 'uuid' in session:
        uuid = session["uuid"]
        global mydb, mycursor
        sql0 = "SELECT * FROM slot_database_details WHERE occupieduuid = %s"
        val0 = (uuid,)
        mycursor.execute(sql0,val0)
        resp = mycursor.fetchone()
        mydb.commit()
        now = datetime.now()
        dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

        starttime, endtime, bill, slotchoosen, ordertedtime = resp[4], dt_string, resp[5], resp[1], resp[3]

        sql1 = "UPDATE slot_database_details SET occupieduuid = %s, orderedtime = %s, startdatetime = %s, currentbill = %s, status = 'AVAILABLE' WHERE occupieduuid=%s"
        val1 = (None, None, None, None, uuid)
        mycursor.execute(sql1,val1)
        mydb.commit()
        sql2 = "SELECT current_balance from user_database WHERE uuid = %s"
        val2 = (uuid,)
        mycursor.execute(sql2, val2)
        balance = mycursor.fetchone()[0]
        mydb.commit()

        balance = int(balance) - 40
        sql3 = "UPDATE user_database SET current_balance = %s WHERE uuid = %s"
        val3 = (balance, uuid)
        mycursor.execute(sql3, val3)
        mydb.commit()

        sql4 = "INSERT INTO all_transaction_details(uuid,datetime,occupiedslot,starttime,endtime,bill,balance,transactdatetime) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"
        now = datetime.now()
        dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
        val4 = (uuid, dt_string, slotchoosen, ordertedtime, endtime, bill, balance, dt_string )

        mycursor.execute(sql4, val4)
        mydb.commit()

        sql5 = "SELECT closing_balance FROM `smart-parking-bank-account-with-transactions` ORDER BY slno DESC LIMIT 1"
        mycursor.execute(sql5)
        closing_balance = mycursor.fetchone()[0]
        mydb.commit()

        sql6 = "INSERT INTO `smart-parking-bank-account-with-transactions`(date_time, from_account, to_account, amount_credited, closing_balance) VALUES (%s,%s,%s,%s,%s)"
        to_account = "121112122212G"
        closing_balance = int(closing_balance)+int(bill)
        val6 = (dt_string,uuid,to_account, bill, closing_balance)
        mycursor.execute(sql6, val6)
        mydb.commit()

        return redirect("/index")


@app.route("/previous-transactions")
def render_previous_transactions():
    if 'uuid' in session:
        uuid = session["uuid"]
        global mydb, mycursor
        sql = "SELECT * FROM all_transaction_details WHERE uuid = %s ORDER BY slno DESC"
        val = (uuid,)
        mycursor.execute(sql, val)
        resp = mycursor.fetchall()
        mydb.commit()
        print(resp)
        return render_template("previous_transactions.html", session = session, data=resp)

    else:
        return redirect("/login")

@app.route("/recharge-wallet")
def render_recharge_wallet():
    if 'uuid' in session:
        uuid = session["uuid"]
        return render_template("recharge-wallet.html", session = session)

    else:
        return redirect("/login")

@app.route("/index")
def render_homepage():
    if 'uuid' in session:
        uuid = session["uuid"]
        sql = "SELECT current_balance FROM `user_database` WHERE uuid= %s"
        val = (uuid,)
        global mycursor, mydb
        mycursor.execute(sql, val)
        balance = mycursor.fetchone()[0]
        mydb.commit()
        sql = "SELECT `slotname`,`status` FROM `slot_database_details`"
        mycursor.execute(sql)
        slots_and_status = mycursor.fetchall()
        mydb.commit()
        print(slots_and_status)
        myresponse = {}
        myresponse["balance"] = balance
        sql = "SELECT slotname, orderedtime, startdatetime, currentbill FROM slot_database_details WHERE occupieduuid = %s"
        val = (uuid,)
        mycursor.execute(sql, val)
        resp = mycursor.fetchone()
        mydb.commit()
        data = {"data":False}
        if resp != None:
            data["data"] = True
            data["slotname"] = resp[0]
            data["orderedtime"] = resp[1]
            data["starttime"] = resp[2]
            now = datetime.now()
            dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
            data["currenttime"] = dt_string
            data["currentbill"] = resp[3]
        
        return render_template("index.html", session = session, resp = myresponse, data=data, slots_update = slots_and_status)

    else:
        return redirect("/login")

@app.route("/book-a-slot")
def render_book_slot():
    if 'uuid' in session:
        uuid = session["uuid"]
        sql = "SELECT `slotname` FROM `slot_database_details` WHERE status='AVAILABLE'"
        mycursor.execute(sql)
        slots_and_status = mycursor.fetchall()
        mydb.commit()
        print(slots_and_status)
        return render_template("book-slot.html", session = session, resp = slots_and_status)

    else:
        return redirect("/login")

@app.route("/book-slot-now", methods = ["POST"])
def book_slot_now():
    uuid = session["uuid"]
    if request.method == "POST":
        now = datetime.now()
        orderedtime = now.strftime("%d/%m/%Y %H:%M:%S")
        selectslot = request.form["selectslot"]
        bill = 40
        sql = "UPDATE slot_database_details SET occupieduuid=%s, orderedtime=%s, currentbill=%s, status=%s WHERE slotname = %s"
        status = "RESERVED"
        val = (uuid, orderedtime, bill, status, selectslot)
        global mycursor, mydb
        mycursor.execute(sql,val)
        mydb.commit()
        return redirect("/index")

    return "WRONG REQUEST METHOD"


@app.route("/logout")
def logout():
    if 'uuid' in session:
        session.clear()
    return redirect("/login")

@app.route('/login')
def render_login():
    if 'uuid' in session:
        uuid = session["uuid"]
        return redirect("/index")
    
    return render_template("login.html")

@app.route('/register')
def render_register():
    if 'uuid' in session:
        uuid = session["uuid"]
        return redirect("/index")
    
    return render_template("register.html")


@app.route("/add-money-to-wallet",methods = ["POST"])
def add_money_to_wallet():
    uuid = session["uuid"]
    if request.method == "POST":
        amount = request.form["amount"]
        sql = "SELECT current_balance FROM `user_database` WHERE uuid = %s"
        val = (uuid,)
        global mycursor, mydb
        mycursor.execute(sql, val)
        resp = mycursor.fetchone()
        value = float(amount)+float(resp[0])
        sql = "UPDATE user_database SET current_balance = %s WHERE uuid = %s"
        val = (value, uuid)
        mydb.commit()
        mycursor.execute(sql, val)
        mydb.commit()
        return redirect("/index")


@app.route("/authenticate-login", methods = ["POST"])
def authenticate_login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        sql = "SELECT password, uuid, name FROM user_database WHERE email = %s"
        val = (email,)
        global mycursor, mydb
        mycursor.execute(sql,val)
        myresult = mycursor.fetchone()
        if myresult != None:
            if sha256_crypt.verify(password, myresult[0]):
                print("VERIFIED SUCCESSFULLY:!")
                session['uuid'] = myresult[1]
                session['loggedIn'] = True
                session['name'] = myresult[2]

                return redirect("/index")
            else:
                print("WRONG PASSWORD, PLEASE TRY AGAIN")
                return "WRONG PASSWORD ENTERED, GOBACK AND TRY AGAIN"

        return "WRONG EMAIL ADDRESS AND PASSWORD"
        

@app.route("/register-account",methods = ['POST'])
def register_account():
    if request.method == 'POST':
      username = str(request.form['firstname'] + " " + request.form['lastname'])
      email  = str(request.form["email"])
      password = sha256_crypt.hash(request.form["password"])
      wallet_pin = request.form["walletpin"]
      opening_balance = float(request.form["openingbalance"])
      
      global mycursor, mydb
      
      sql = "INSERT INTO user_database (uuid, name, email, password, current_balance, wallet_pin) VALUES (UUID(), %s, %s, %s, %s, %s)"
      val = (username, email, password, opening_balance, wallet_pin)
      mycursor.execute(sql, val)
      mydb.commit()
      print(mycursor.rowcount, "record inserted.")
      return redirect("login")

if __name__ == '__main__':
    app.run(host=IP_ADDRESS, port= PORT, threaded=True, debug=True)
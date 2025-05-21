from flask import Flask
import psycopg2

app = Flask(__name__)

@app.route("/")
def db_check():
    try:
        conn = psycopg2.connect(
            dbname="mydb", user="user", password="pass", host="db"
        )
        return "Connected to PostgreSQL"
    except Exception as e:
        return str(e)

if __name__ == "__main__":
    app.run(host="0.0.0.0")

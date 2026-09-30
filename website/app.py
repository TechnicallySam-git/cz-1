from flask import Flask, render_template, jsonify, request, redirect, url_for, session
import urllib.request
import os
import pymysql

app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET_KEY"]

USERNAME = os.environ.get("APP_USERNAME", "admin")
PASSWORD = os.environ["APP_PASSWORD"]

DB_HOST = os.environ.get("DB_HOST")
DB_PORT = int(os.environ.get("DB_PORT", 3306))
DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")


def get_instance_metadata():
    """Fetch basic EC2 metadata using IMDSv2 (token-based)."""
    try:
        token_req = urllib.request.Request(
            "http://169.254.169.254/latest/api/token",
            method="PUT",
            headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"},
        )
        token = urllib.request.urlopen(token_req, timeout=1).read().decode()

        def meta(path):
            req = urllib.request.Request(
                f"http://169.254.169.254/latest/meta-data/{path}",
                headers={"X-aws-ec2-metadata-token": token},
            )
            return urllib.request.urlopen(req, timeout=1).read().decode()

        return {
            "instance_id": meta("instance-id"),
            "instance_type": meta("instance-type"),
            "availability_zone": meta("placement/availability-zone"),
            "private_ip": meta("local-ipv4"),
            "hostname": meta("hostname"),
        }
    except Exception as e:
        return {"error": str(e)}


def check_db_connection():
    if not DB_HOST:
        return {"status": "not configured", "detail": "DB_HOST not set"}
    info = {"host": DB_HOST, "port": DB_PORT}
    try:
        conn = pymysql.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            connect_timeout=3,
        )
        with conn.cursor() as cur:
            cur.execute("SELECT VERSION()")
            version = cur.fetchone()[0]
        conn.close()
        return {"status": "connected", "version": version, **info}
    except pymysql.err.OperationalError as e:
        # 2003 = can't reach the server; anything else (e.g. 1045) = reached it but rejected us
        unreachable = e.args and e.args[0] == 2003
        return {
            "status": "unreachable" if unreachable else "reachable but login failed",
            "error": str(e),
            **info,
        }
    except Exception as e:
        return {"status": "reachable but login failed", "error": str(e), **info}


@app.route("/")
def index():
    if not session.get("logged_in"):
        return redirect(url_for("login"))
    return redirect(url_for("dashboard"))


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        if request.form.get("username") == USERNAME and request.form.get("password") == PASSWORD:
            session["logged_in"] = True
            return redirect(url_for("dashboard"))
        error = "Invalid username or password"
    return render_template("login.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.route("/dashboard")
def dashboard():
    if not session.get("logged_in"):
        return redirect(url_for("login"))
    return render_template(
        "dashboard.html",
        instance=get_instance_metadata(),
        db=check_db_connection(),
    )


@app.route("/health")
def health():
    return {"status": "ok"}, 200


@app.route("/api/hello")
def hello():
    return jsonify(message="Hello from EC2 ASG Assigned")
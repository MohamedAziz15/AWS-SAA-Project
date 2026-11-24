"""Tiny demo app: shows which instance/AZ served the request and checks the RDS connection.

GET /        -> HTML page (instance id, AZ, DB status, visit counter stored in MySQL)
GET /health  -> 200 "ok" (used by the ALB target group health check)
"""
import json
import os
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import boto3
import pymysql

REGION = os.environ["AWS_REGION"]
SECRET_ARN = os.environ["DB_SECRET_ARN"]
DB_HOST = os.environ["DB_HOST"]
DB_NAME = os.environ["DB_NAME"]
PORT = int(os.environ.get("APP_PORT", "80"))


def imds(path):
    token_req = urllib.request.Request(
        "http://169.254.169.254/latest/api/token",
        method="PUT",
        headers={"X-aws-ec2-metadata-token-ttl-seconds": "300"},
    )
    token = urllib.request.urlopen(token_req, timeout=2).read().decode()
    req = urllib.request.Request(
        f"http://169.254.169.254/latest/meta-data/{path}",
        headers={"X-aws-ec2-metadata-token": token},
    )
    return urllib.request.urlopen(req, timeout=2).read().decode()


INSTANCE_ID = imds("instance-id")
AZ = imds("placement/availability-zone")
_creds = None


def db_connect():
    global _creds
    if _creds is None:
        sm = boto3.client("secretsmanager", region_name=REGION)
        _creds = json.loads(sm.get_secret_value(SecretId=SECRET_ARN)["SecretString"])
    return pymysql.connect(
        host=DB_HOST,
        user=_creds["username"],
        password=_creds["password"],
        database=DB_NAME,
        connect_timeout=3,
        ssl={"ca": "/opt/app/rds-ca.pem"},  # RDS enforces TLS (require_secure_transport)
    )


def visit():
    with db_connect() as conn, conn.cursor() as cur:
        cur.execute("CREATE TABLE IF NOT EXISTS visits (id INT AUTO_INCREMENT PRIMARY KEY, instance VARCHAR(32), ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cur.execute("INSERT INTO visits (instance) VALUES (%s)", (INSTANCE_ID,))
        cur.execute("SELECT COUNT(*) FROM visits")
        count = cur.fetchone()[0]
        conn.commit()
        return count


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body, ctype="text/html"):
        data = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/health":
            return self._send(200, "ok", "text/plain")
        if self.path != "/":
            return self._send(404, "not found", "text/plain")
        try:
            count = visit()
            db = f"connected, total visits: {count}"
        except Exception as exc:  # show the error instead of failing the page
            db = f"error: {exc.__class__.__name__}"
        html = f"""<!doctype html><html><head><title>Manara SAA Project 1</title>
<link rel="stylesheet" href="/static/style.css"></head><body>
<h1>Scalable Web App on AWS</h1>
<p>Served by <b>{INSTANCE_ID}</b> in <b>{AZ}</b></p>
<p>Database (RDS Multi-AZ): {db}</p>
<p><img src="/static/logo.svg" alt="logo" width="120"></p>
</body></html>"""
        self._send(200, html)

    def log_message(self, fmt, *args):
        print(f"{self.address_string()} {fmt % args}", flush=True)


if __name__ == "__main__":
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()

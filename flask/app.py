from flask import Flask, request
from markupsafe import escape
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)

app.wsgi_app = ProxyFix(
    app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1
)

@app.route("/")
def hello():
    name = request.args.get("name", "World")
    return f"Hello, {escape(name)}! COOL!"

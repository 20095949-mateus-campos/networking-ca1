# Module Title:         Network Systems and Administration
# Module Code:          B9IS121
# Module Instructor:    Kingsley Ibomo
# Assessment Title:     Automated Container Deployment and Administration in the Cloud
# Assessment Number:    1
# Assessment Type:      Practical
# Assessment Weighting: 60%
# Assessment Due Date:  Sunday, 9 November 2025, 8:36 AM
# Student Name:         Mateus Fonseca Campos
# Student ID:           20095949
# Student Email:        20095949@mydbs.ie
# GitHub Repo:          https://github.com/20095949-mateus-campos/networking-ca1

# This file belongs to Part 3: Docker Container Deployment

from flask import Flask, request
from markupsafe import escape
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)

app.wsgi_app = ProxyFix(
    app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1
)

@app.route("/")
def hello_student():
    version = 2

    if version == 1:
        # Version #1
        # Test parameters:
        # /?fname=Mateus&mname=Fonseca&lname=Campos

        fname = request.args.get("fname", "student")
        mname = request.args.get("mname", "")
        lname = request.args.get("lname", "")

        return f"<h1>Hello, {escape(fname)} {escape(mname)} {escape(lname)}!</h1>"
    elif version == 2:
        # Version #2
        # Test parameters:
        # /?fname=Mateus&mname=Fonseca&lname=Campos&std_id=20095949&repo=networking-ca1

        fname = request.args.get("fname", "")
        mname = request.args.get("mname", "")
        lname = request.args.get("lname", "")
        std_id = request.args.get("std_id", "")
        repo = request.args.get("repo", "")

        return f"""
        <h1>Dublin Business School</h1>
        <p><b>Module Title:</b>         Network Systems and Administration</p>
        <p><b>Module Code:</b>          B9IS121</p>
        <p><b>Module Instructor:</b>    Kingsley Ibomo</p>
        <p><b>Assessment Title:</b>     Automated Container Deployment and Administration in the Cloud</p>
        <p><b>Assessment Number:</b>    1</p>
        <p><b>Assessment Type:</b>      Practical</p>
        <p><b>Assessment Weighting:</b> 60%</p>
        <p><b>Assessment Due Date:</b>  Sunday, 9 November 2025, 8:36 AM</p>
        <p><b>Student Name:</b>         {escape(fname)} {escape(mname)} {escape(lname)}</p>
        <p><b>Student ID:</b>           {escape(std_id)}</p>
        <p><b>Student Email:</b>        <a href="mailto:{escape(std_id)}@mydbs.ie">{escape(std_id)}@mydbs.ie</a></p>
        <p><b>GitHub Repo:</b>          <a href="https://github.com/{escape(std_id)}-{escape(fname).lower()}-{escape(lname).lower()}/{escape(repo)}" target="_blank">https://github.com/{escape(std_id)}-{escape(fname).lower()}-{escape(lname).lower()}/{escape(repo)}</a></p>
        """
    else:
        return "<h1>Something went wrong!</h1>"

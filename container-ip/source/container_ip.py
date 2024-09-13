
from flask import Flask
from flask import render_template
from requests.exceptions import RequestException as RequestException
import requests
import socket
import os

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config['PROPAGATE_EXCEPTIONS'] = True

@app.errorhandler(500)
def internal_server_error(error):
    return "HTTP 500 error"

@app.errorhandler(404)
def not_found_error(error):
    not_found_msg = """
    <h1>These are not the droids you are looking for.</h1>
    """
    return not_found_msg

@app.route('/')
def index():
    host_ip = socket.gethostbyname(socket.gethostname())
    return render_template("index.html",
    host_ip=host_ip,version=os.environ['GIT_VERSION'])

if __name__ == '__main__':
    app.run(
        host="0.0.0.0",
        port="80")

from github_webhook import Webhook
from flask import Flask
import os

SECRET=None
if os.getenv("SECRET"):
  SECRET=os.getenv("SECRET")

#print ("Got secret '%s'" % (SECRET))

app = Flask(__name__)  # Standard Flask app
webhook = Webhook(app, secret=SECRET) # Defines '/postreceive' endpoint

@app.route("/")        # Standard Flask endpoint
def hello_world():
    return "Hello, World!"

@webhook.hook()        # Defines a handler for the 'push' event
def on_push(data):
    print("Got push with: {0}".format(data))
    print("Executing start!")
    os.system("hooks/postreceive.py")
    print("Executing done!")

if __name__ == "__main__":
    from waitress import serve
    serve(app, host="0.0.0.0", port=5000)


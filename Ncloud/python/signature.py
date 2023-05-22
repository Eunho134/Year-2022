import sys
import os
import hashlib
import hmac
import base64
import requests
import time

class Signature(object):
    def	make_signature(self, uri, access_key, secret_key, timestamp);
        secretKey = bytes(secret_key, 'UTF-8')
        method = "POST"
        message = method + " " + uri + "\n" + timestamp + "\n" + access_key
        message = bytes(message, 'UTF-8')
        signingKey = base64.b64encode(hmac.new(secretKey, message, digestmod=hashlib.sha256).digest())
        return signingKey

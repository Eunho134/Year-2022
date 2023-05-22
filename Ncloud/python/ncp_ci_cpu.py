import sys
import os
import hashlib
import hmac
import base64
import requests
import time
import json
import urllib
import random
import gspread
import pandas as pd
import gspread_dataframe as gd
#from signature import Signature

access_key = "1B910506896827066B04"
secret_key = "A7838E7BCBC9F1FCA7635A11DB1C713312C72E7B"

timestamp = str(int(time.time() * 1000))

######################### API GATEWAY ###################################

url = "https://cw.apigw.gov-ntruss.com"

######################### 호       출 ###################################
requestUrl = "/cw_fea/real/cw/api/data/query"

body = {
        "timeStart": "1680274800",
        "timeEnd": "1682866799",
        "cw_key": "769530112713560064",
        "productName": "System/Server", 
        "metric": "used_rto",
        "interval": "Day1",
        "aggregation": "AVG",
        "dimensions": {
            "instanceNo": "994954",
            "type": "cpu"       
    }       
}

######################### 헤       더 ###################################

uri = requestUrl
apiUrl = url + uri

method = "POST"
message = method + " " + uri + "\n" + timestamp + "\n" + access_key
message = bytes(message, 'UTF-8')           
secretKey = bytes(secret_key, 'UTF-8')
signingKey = base64.b64encode(hmac.new(secretKey, message, digestmod=hashlib.sha256).digest())

headers = {
    'Content-Type': 'application/json',
    'x-ncp-iam-access-key': access_key,
    'x-ncp-apigw-timestamp': timestamp,
    'x-ncp-apigw-signature-v2': signingKey,
}

res = requests.post(apiUrl, headers=headers, json=body)

print (res.json())


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
from signature import Signature

access_key = "FB67FE48026813C8FE25"
secret_key = "6F9D9938CB08D4E33F6DF38A8F7D4BC70BC4A0F8"



timestamp = str(int(time.time() * 1000))

######################### API GATEWAY ###################################

url = "https://ncloud.apigw.ntruss.com"

######################### 호       출 ###################################
requestUrl = "/vserver/v2/getBlockStorageInstanceList"

body = {
     "regionCode": "KR",
     "responseFormatType": "json",
}

######################### 헤       더 ###################################
uri = requestUrl
apiUrl = url + uri
m = Signature()
headers = {
    'x-ncp-iam-access-key': access_key,
    'x-ncp-apigw-timestamp': timestamp,
    'x-ncp-apigw-signature-v2': m.make_signature(uri, access_key, secret_key, timestamp),
}
res = requests.post(apiUrl, headers=headers, data=body)

#########################################################################
#print(res.request)
#print(res.headers)
#res_status = res.status_code
#print("StatusCode", res_status)
#print(res.json())

######################### Storage List ##################################
result = res.json().get("getBlockStorageInstanceListResponse").get("blockStorageInstanceList")

######################### Storage Count #################################
total = res.json().get("getBlockStorageInstanceListResponse").get("totalRows")

######################### 결 과 출 력 ###################################
for i in range(total):
    size = result[i].get("blockStorageSize")
    size = size / 1073741824
    diskType = result[i].get("blockStorageDiskDetailType")
    diskType = diskType.get("code")
    storageType = result[i].get("blockStorageType")
    storageType = storageType.get("code")
    print("Storage Name :" ,result[i].get("blockStorageName"), "Size :",size,"GB" ,"Disk Type :",diskType ,"Storage Type :",storageType ,"attached Server :" ,result[i].get("serverInstanceNo"))
#print(result.get("getServerInstanceListResponse").get("serverIncetanceList"))
#svrInsList = list(result.get("getServerInstanceListResponse").get("serverInstanceList"))
#print(svrInsList)

    

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

url = "https://ncloud.apigw.gov-ntruss.com"

######################### 호       출 ###################################
requestUrl = "/server/v2/getServerInstanceList"

body = {
     "regionCode": "KR",
     "responseFormatType": "json",
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
    'x-ncp-iam-access-key': access_key,
    'x-ncp-apigw-timestamp': timestamp,
    'x-ncp-apigw-signature-v2': signingKey,
}
res = requests.post(apiUrl, headers=headers, data=body)


#########################################################################
#print(res.request)
#print(res.headers)
#res_status = res.status_code
#print("StatusCode", res_status)
#print(res.json())

######################### Instance List #################################
result = res.json().get("getServerInstanceListResponse").get("serverInstanceList")

######################### Instance Count ################################
total = res.json().get("getServerInstanceListResponse").get("totalRows")

######################### 결 과 출 력 ####################################
for i in range(total):
    size = result[i].get("memorySize")
    size = size / 1073741824
    
    print("Server :" ,result[i].get("serverName"),"-",result[i].get("serverInstanceNo") ,"CPU :" ,result[i].get("cpuCount"),"Core" ,"Memory :" ,size,"GB" ,"Public IP :" ,result[i].get("publicIp") ,"Zone :" ,result[i].get("zoneCode") ,"OS :" ,result[i].get("serverImageProductCode") ,"Status :" ,result[i].get("serverInstanceStatusName") ,"Up Time :" ,result[i].get("uptime"))
    

######################### 시 트 호 출 ####################################    
#gc = gspread.service_account(filename="./sheetapi.json")   
#sheetName = "K-Cloud 자산 대장"
#spreadSheet = gc.open(sheetName)

#sheet = spreadSheet.worksheet("NCP_row_data")

######################### 개 행 ##########################################
#def next_available_row(sheet):
#    int_list = list(filter(None, sheet.col_values(1)))
#    return len(int_list)+1

#next_row = next_available_row(sheet)

####### dataframe 사용 #######
#df = pd.DataFrame(result)
# # df.drop(['serverDescription', 'platformType', 'loginKeyName', 'publicIpInstanceNo', 'serverInstanceStatus', 'serverInstanceOperation', 'createDate', 'regionCode', 'serverProductCode', 'isProtectServerTermination', 'vpcNo', 'subnetNo', 'networkInterfaceNoList', 'initScriptNo', 'serverInstanceType', 'baseBlockStorageDiskType', 'baseBlockStorageDiskDetailType', 'placementGroupNo', 'placementGroupName', 'memberServerImageInstanceNo'], axis=1, inplace=True)

#df['memorySize'] = df['memorySize'].astype('float32') / 1073741824

#gd.set_with_dataframe(sheet, df, include_column_header=False, row=next_row)




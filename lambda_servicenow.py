import json
import boto3
import botocore
import gzip
from botocore.vendored import requests

def lambda_handler(event, context):
    # TODO implement
    for r in event['Records']:
        #print("test")
        payload=r['body']
        d = json.loads(payload)
        #print  (d['Message'])
        d1 = json.loads(d['Message'])
        b_name = (d1['s3Bucket'])
        b_path = (d1['s3ObjectKey'][0])
        gets3bucketdata(b_name, b_path)
    return {
        "statusCode": 200,
        "body": json.dumps('Hello from Lambda!')
    }


def gets3bucketdata(bucket_name, bucket_path):
    s3 = boto3.resource('s3')
    try:
        s3.Bucket(bucket_name).download_file(bucket_path, '/tmp/temp.gz')
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == '404':
            print('The object dose not exist')
        else: 
            raise 
    createpayload('/tmp/temp.gz')       

def createpayload(gzipfile):
    with gzip.open(gzipfile, 'rb') as f:
        data = json.loads(f.read().decode('ascii'))

    for d in data['Records']:
                if (d['responseElements']) is None:
                    pass
                else:
                    if 'groupSet' in d['responseElements']:
                        try:
                            # I can now loop thru each element in the list 1000
                                amiLaunchIndex   = (d['responseElements']['instancesSet']['items'][0]['amiLaunchIndex'])    
                                instanceType     = (d['responseElements']['instancesSet']['items'][0]['instanceType'])    
                                imageId          = (d['responseElements']['instancesSet']['items'][0]['imageId'])    
                                instanceId       = (d['responseElements']['instancesSet']['items'][0]['instanceId'])    
                                hypervisor       = (d['responseElements']['instancesSet']['items'][0]['hypervisor'])    
                                availabilityZone = (d['responseElements']['instancesSet']['items'][0]['placement']['availabilityZone'])    
                         # build payload   
                                payload = {"attributes":
                                           {
                                            "discovery_source": "AWS - Web Service load",
                                            "name": instanceId,
                                            "short_description": "EC2-instance",
                                            "u_hosted_by" : "AWS",
                                            "serial_number": imageId,
                                            "virtual": hypervisor,
                                            "install_status": "7",
                                            "u_flavor": instanceType,
                                            "category": "CMDB",
                                            "u_ci_scope": "1",
                                            "u_owned_by_group": "f91586662bf4f1004bf2bd63e4da15cb",
                                            "location": availabilityZone,
                                            "owned_by":  "ebe9bd6381196dc03be36f6f0ca34c82",
                                            "u_domain": "68d7bbb12b1439006ac90fe119da1576",
                                            "location": availabilityZone,
                                            "u_business_service": "88972bf22bf83500be1f1c9069da1539",
                                            "support_group":  "bd1586662bf4f1004bf2bd63e4da15fe",
                                            "u_hosted_by": availabilityZone,
                                            "u_managed_by_group": "bd1586662bf4f1004bf2bd63e4da15fe",
                                            "model_id" : imageId,
                                            "manufacturer": "AWS",
                                           }
                                          }
                                postme(payload)

                        except KeyError:
                            pass
                        except:
                            print ('I got another exception, but I should re-raise')
                            raise


def postme(v):
    url     = 'https://XXXXX.service-now.com/api/now/cmdb/instance/cmdb_ci_linux_server'
    user    = 'XXXX'
    pwd     = 'XXXXXX'
    payload = v
 # Set proper headers
    headers = {"Content-Type":"application/json","Accept":"application/json"}
    print ("posting to https://XXXXXX.service-now.com/api/now/cmdb/instance/cmdb_ci_linux_server")
    response = requests.post(url, auth=(user, pwd), headers=headers, data=json.dumps(payload))
    if response.status_code != 201:
         print ("YES THIS IS BAD:")
         print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
         exit()
    print('Status:',response.status_code,'Headers:',response.headers,'Response:',response.json())
    print('Cookies', response.cookies)


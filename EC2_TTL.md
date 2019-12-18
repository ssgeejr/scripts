In dynamic cloud environments, customers often spin up resources for short lived workloads (e.g., dev/test environments). These resources are often forgotten after the tests are complete and remain active—and billable.

A desired feature for cloud cost management is a time to live (TTL) parameter that automatically terminates a provisioned resource after a specified period of time. AWS offers TTL capabilities for certain resources, such as DynamoDB, S3, and AWS CloudFormation sets-up TTL on entire application stack. However, there is no easy way to set TTL on EC2 instances, which constitute the bulk of cloud spend for most AWS customers.

Here are a few techniques to implement TTL for AWS EC2 instances.

Lambda functions can periodically scan for EC2 instances, identify instances with specific tags running longer than the required TTL, and stop/terminate them.
Scripts that run on EC2 instances that periodically check of EC2 life and stop/terminate unused ones.
Create instances with a ‘terminate on shutdown’ flag and force a shutdown at the end of the test.
At Apptio, we use extensive scripting in our engineering environment and terminating unused instances is something we keep an eye out for. We use a very simple script to do this. Our requirements are quite simple – we need instances created from a specific AMI or with specific tags to run only for a certain period of time.

You will see below a simple script to list and stop EC2 instances that have been running longer the specified period of time.

Usage is as below:

usage: ec2TTL.py [-h] -a ACCESSKEY -s SECRETKEY -r REGIONS [REGIONS ...]
[-i AMIID] -t TTLINHOURS [-k TAGKEY] [-v TAGVALUE] [-x STOP]

optional arguments:

-h, --help            show this help message and exit
-a ACCESSKEY, --access-key ACCESSKEY
-s SECRETKEY, --secret-key SECRETKEY
-r REGIONS [REGIONS ...], --regions REGIONS [REGIONS ...]
-i AMIID, --amiId AMIID
-t TTLINHOURS, --ttl TTLINHOURS
-k TAGKEY, --tagKey TAGKEY
-v TAGVALUE, --tagValue TAGVALUE
-x STOP, --stop STOP

AMIID, TagKey, TagValue are Optional. If an AMIID is specified, only instances created from the AMI are reported.

If TagKey/TagValue are specified only instances with specified tags are listed. Use -x option if instances should be stopped. (Terminate instances is deliberately not provided, but could be easily added). One could simply automate the process by running this script periodically (using tools such as cron on Linux).
```
import os
import boto3
import botocore
import arrow
import datetime
import pytz
import argparse
from dateutil.tz import *
import sys
import re

class EC2Lib:
    def __init__(self, accessKey, secretKey, region, SessionToken=None):
        self.accessKey      = accessKey
        self.secretKey      = secretKey
        self.region         = region
        self.sessionToken   = SessionToken

        try:
            self.client  = boto3.client('ec2',
                                           aws_access_key_id=self.accessKey,
                                           aws_secret_access_key=self.secretKey,
                                           region_name=self.region)
        except botocore.exceptions.ClientError as e:
            eMsg = e.response['Error']['Message']
            print('error in create session %s' %eMsg)
        except:
            e = sys.exc_info()[0]
            print('error in create session %s' %e)

    #
    # Reports list of EC2 instances that are older than specified TTL
    # If amiId is specified only instanaces created from the specified AMI is returned
    # If tagName/Value is specified returns only matching instances. Tags can be regular expressions
    #
    def ListEC2Instances(self, amiId=None, ttlInHours=None, tagKey=None, tagValue=None):
        try:

            Filters = [{'Name': 'instance-state-name', 'Values': ['running']}]
            if amiId != None:
                Filters.append({'Name': 'image-id', 'Values': [amiId]})
            
            response = self.client.describe_instances(Filters=Filters)
        except botocore.exceptions.ClientError as error:
            print("Failed to describe instances %s" %(error.response['Error']['Message']))
            return []
        except:
            e = sys.exc_info()[0]
            print("Failed to call boto3.client describe instance %s" %(e))
            return []

        ec2List = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:

                now = datetime.datetime.now(pytz.timezone('UTC'))
                timeToCheck = now - datetime.timedelta(hours=ttlInHours)

                if instance['LaunchTime'] < timeToCheck:
                    # Find tag named 'Name' (for easier identification of instance)
                    instanceName = 'NoName'
                    for tags in (instance['Tags']):
                        if (tags['Key'] == 'Name'):
                            instanceName = tags['Value']
                            break

                    # If no tag specified add item to list
                    if tagKey == None:
                        ec2List.append({'id': instance['InstanceId'], 'name':instanceName, 'launchTime':instance['LaunchTime']})
                        continue

                    # Tag name/value specified, search for specified tags
                    regexKey   = re.compile(tagKey)
                    regexValue = re.compile(tagValue)

                    for tag in instance['Tags']:
                        if re.match(regexKey, tag['Key'] ) and re.match( regexValue, tag['Value']):
                            ec2List.append({'id': instance['InstanceId'], 'name':instanceName, 'launchTime':instance['LaunchTime']})
                            break
                    
        return ec2List

    def StopInstance(self, ec2Id):
        try:
            response = self.client.stop_instances( InstanceIds=[ec2Id], Force=True)
        except botocore.exceptions.ClientError as e:
            print('Error stopping ec2 = %s, error = %s' %(ec2Id, e.response['Error']['Message']))
            return False
        except:
            print("Failed to call boto3.client for ec2 %s" %ec2Id)
            return False
        return True


def ParseArgs(arg):
    parser = argparse.ArgumentParser()

    parser.add_argument("-a", "--access-key", dest="accessKey", required=True)
    parser.add_argument("-s", "--secret-key", dest="secretKey", required=True)
    parser.add_argument("-r", "--regions", dest="regions", nargs='+', required=True)
    parser.add_argument("-i",  "--amiId", dest="amiId", default=None, required=False)
    parser.add_argument("-t", "--ttl", type=int, dest="ttlInHours", default=None, required=True)
    parser.add_argument("-k", "--tagKey", dest="tagKey", default=None, required=False)
    parser.add_argument("-v", "--tagValue", dest="tagValue", default=None, required=False)
    parser.add_argument("-x", "--stop", dest="stop", default=False, required=False)
    
    return parser.parse_args()

if __name__ == "__main__":
    args = ParseArgs(sys.argv)

    instancesStopped = 0
    for region in args.regions:
        ec2Lib = EC2Lib(args.accessKey, args.secretKey, region)

        ec2List = ec2Lib.ListEC2Instances(args.amiId, args.ttlInHours, args.tagKey, args.tagValue)

        for ec2 in ec2List:
            now = arrow.now()
           print('%s, %s, %s, %d days %d hours alive' %(ec2['id'], ec2['name'], ec2['launchTime'].strftime('%Y-%m-%d %H:%M:%S'),
                         (now.datetime-ec2['launchTime']).days, (now.datetime-ec2['launchTime']).seconds/60/60))

            if args.stop:
                if ec2List.StopInstance(ec2['id']) == True:
                    print( 'EC2 %s, %s stopped' %(ec2['id'], ec2['name']))
                    instancesStopped += 1

    print('%d EC2 instances alive longer than %d hours stopped' %(instancesStopped, args.ttlInHours ))
```

Sourced from: https://www.apptio.com/emerge/simple-script-implement-aws-ec2-ttl-time-live/


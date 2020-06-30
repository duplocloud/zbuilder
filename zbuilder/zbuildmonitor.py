#!/usr/bin/env python
import sys
import os
import os.path
import traceback
import subprocess
import time
import boto3

# from boto.s3.key import Key
#def upload_file(file_name, bucket, object_name=None):
def s3Upload(targetFile, srcFile):
    lFileExists = os.path.isfile(srcFile)
    print('Call to upload ' + srcFile + ' toFile ' + targetFile)
    if lFileExists != True:
        print('**** Requested file does not exist yet')
        return

    bucket = os.getenv('S3_BUCKET')
    s3_client = boto3.client('s3')

    targetFile = os.getenv('GIT_REPO') + '/' + targetFile
    print('**** uploading file ' + srcFile + ' toFile ' + bucket + '/' + targetFile)
    response = s3_client.upload_file(srcFile, bucket, targetFile)
    print('**** uploaded file ' + srcFile + ' toFile ' + bucket + '/' + targetFile)

# def s3Upload(targetFile, srcFile):
#     lFileExists = os.path.isfile(srcFile)
#     print 'Call to upload ' + srcFile + ' toFile ' + targetFile
#     if lFileExists != True:
#         print '**** Requested file does not exist yet'
#         return
#     targetFile = os.getenv('GIT_REPO') + '/' + targetFile
#     bucketName = os.getenv('S3_BUCKET')
#     conn = boto.connect_s3()
#     b = conn.get_bucket(bucketName)
#     k = Key(b)
#     k.key = targetFile
#     k.set_contents_from_filename(srcFile)


def uploadLogs(aInRunning):
    print('Begin log upload')
    logFileName = os.getenv('LOG_FILE')
    logFileName = logFileName + '_' + os.getenv('REPLICA_ID')
    # Upload the files
    s3Upload(logFileName, '/zbuild.log')

    if aInRunning == False:
        logFileName = '/' + logFileName + '.complete'
        s3Upload(logFileName, logFileName)


def isBuildRunning():
    val = subprocess.check_output(["ps", "-ax"])
    lStatus = val.decode("utf-8") 
    lProcs = lStatus.splitlines()
    print("Build is still running ", lStatus)

    lRunning = False
    for lProc in lProcs:
        if 'zbuild.sh' in lProc:
            print("Build is still running")
            lRunning = True
            break
    if lRunning == False:
        print('Build is not running')

    return lRunning

def launchBuild():
   os.system("/bin/bash /zbuild.sh &")


def main():
    print("Starting Build Process")
    lRunning = isBuildRunning()

    if lRunning == False:
        print('Starting new build')
        launchBuild()
    else:
        print('Old build is running')

    print("Starting build monitor")
    #import pdb; pdb.set_trace()
    lRunning = False
    while(True):
        time.sleep(10)

        try:
            lRunning = isBuildRunning()
            uploadLogs(lRunning)
            if lRunning == False:
                break
        except Exception as e:
            # import pdb; pdb.set_trace()
            print("********************************************* UpdateLogs encountered an exception", sys.exc_info()[0])
        print('=============================================== Updatelogs Completed')

    print('No more log upload go to idle state')
    # Wait for the master to kill
    while(True):
        time.sleep(60)


if __name__ == '__main__':
   main()

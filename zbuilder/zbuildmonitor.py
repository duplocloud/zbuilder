#!/usr/bin/env python
import sys
import os
import os.path
import traceback
import subprocess
import time
import boto3

from boto3.s3.transfer import S3Transfer

def s3Upload(targetFile, srcFile):
    lFileExists = os.path.isfile(srcFile) 
    print ('Call to upload ' + srcFile + ' toFile ' + targetFile)
    if not lFileExists:
        print ('**** Requested file does not exist yet')
        return
    targetFile = os.getenv('GIT_REPO') + '/' + targetFile
    bucketName = os.getenv('S3_BUCKET')
    s3_client = boto3.client('s3')
    s3_client.upload_file(srcFile, bucketName, targetFile)

def uploadLogs(aInRunning):
    print ('Begin log upload. Running status: ' + str(aInRunning))
    logFileName = os.getenv('LOG_FILE')
    logFileName = logFileName + '_' + os.getenv('REPLICA_ID')
    # Upload the files
    s3Upload(logFileName, '/zbuild.log') 
    
    if not aInRunning:
        print ('build is complete. Running status: ' + str(aInRunning))
        logFileName = logFileName + '.complete'
        s3Upload(logFileName, '/' + logFileName)
    

def isBuildRunning():
    val = subprocess.check_output(["ps", "-ax"]).decode("utf-8")
    lProcs = val.splitlines()
    lRunning = False
    for lProc in lProcs:
        if 'zbuild.sh' in lProc:
            print ("Build is still running")
            lRunning = True
            break
    if not lRunning:
        print ('Build is not running')
 
    return lRunning
       
def launchBuild():
   subprocess.Popen(["/bin/bash", "/zbuild.sh"])

    
def main():
    print ("Starting Build Process")
    lRunning = isBuildRunning()

    if not lRunning:
        print ('Starting new build')
        launchBuild()
    else:
        print ('Old build is running')
 
    print ("Starting build monitor")
    #import pdb; pdb.set_trace()
    lRunning = False
    while True:
        time.sleep(10)
        
        try:
            lRunning = isBuildRunning()
            uploadLogs(lRunning)
            if not lRunning:
                break
        except Exception as e:
            # import pdb; pdb.set_trace()
            print ("********************************************* UpdateLogs encountered an exception", sys.exc_info()[0])
        print ('=============================================== Updatelogs Completed')
     
    print ('No more log upload go to idle state')
    # Wait for the master to kill	      
    while True:
        time.sleep(60)


if __name__ == '__main__':
   main()

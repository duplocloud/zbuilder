#!/usr/bin/env python3
import sys
import os
import os.path
import traceback
import subprocess
import time
import boto3

def s3Upload(targetFile, srcFile):
    lFileExists = os.path.isfile(srcFile) 
    print('Call to upload ' + srcFile + ' toFile ' + targetFile)
    if lFileExists != True:
        print('**** Requested file does not exist yet')
        return
    targetFile = os.getenv('GIT_REPO') + '/' + targetFile
    bucketName = os.getenv('S3_BUCKET')
    s3 = boto3.resource('s3')
    s3.Object(bucketName, targetFile).put(Body=open(srcFile, 'rb'))

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
    lRunning = False
    while(True):
        time.sleep(10)
        
        try:
            lRunning = isBuildRunning()
            uploadLogs(lRunning)
            if lRunning == False:
                break
        except(Exception):
            print("********************************************* UpdateLogs encountered an exception", sys.exc_info()[0])
        print('=============================================== Updatelogs Completed')
     
    print('No more log upload go to idle state')
    # Wait for the master to kill	      
    while(True):
        time.sleep(60)


if __name__ == '__main__':
   main()
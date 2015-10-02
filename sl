#!/usr/bin/python

import urllib
import os
import sys
import subprocess
import json

# This script first executes the command passed as argument, then, when the command 
# is done, it sends you a slack notifications through slackbot. 
# 
# All you need to do is define the SLACK_USER and SLACK_URL environment variables with: 
# SLACK_USER: your slack username
# SLACK_URL: the incomming message hook url
#
# Uses:
# sl ls -al 
# sl sleep 10s
# sl make
# sl ENV_VAR=FOO make 
# ...

host = os.environ.get('HOSTNAME','Unknown host').split('.')[0] 
user = os.environ.get('SLACK_USER')
url = os.environ.get('SLACK_URL')

if not user: 
   print "Slack error: SLACK_USER not found"
   sys.exit(1)
if not url: 
   print "Slack error: SLACK_URL not found"
   sys.exit(1)
def sendSlackMessage(message): 
   # Sends a Yo to the user defined in the envrionement variable YO_USER with the 
   # Yo account corresponding to the token defined in the environement variable 
   # YO_TOKEN.
   message = message.replace('&','&amp')
   message = message.replace('<','&lt')
   message = message.replace('>','&gt')
   data = {
      'payload':json.dumps({
         'channel': '@'+user,
         'username': host, 
         'text': 'The following command finished: `'+message+'`'
      })
   }
   request = urllib.urlopen(url,urllib.urlencode(data))
   res = request.read()
   if not res=='ok': 
      print 'Slack error: "'+res+'"'

   
command = ' '.join(sys.argv[1:])
# Get the command back
process = subprocess.Popen(command,shell=True)
# Execute the command
process.wait()
# Wait for the command execution to finish
sendSlackMessage(command)
# Send a slack notification to the slackbot channel once the task is done

#!/usr/bin/python

# From: https://github.com/ChrisJamesC/sl.ack/

# This script first executes the command passed as argument, then, when the command 
# is done, it sends you a slack notifications through slackbot. 
# 
# All you need to do is define the SLACK_USER and SLACK_URL environment variables with: 
# SLACK_USER: your slack username
# SLACK_URL: the incomming message hook url
# In order to obtain this URL, create an incomming web hook in https://slack.com/apps 
# and configure it for the channel @slackbot if you don't want to post on a 
# channel but send direct messages to yourself. 
# 
# Additionally, you can also set the HOSTNAME in order for slack to know what 
# host the message comes from. 
#
# Uses:
# sl ls -al 
# sl sleep 10s
# sl make
# sl ENV_VAR=FOO make 
# ...

import urllib
import os
import sys
import subprocess
import json


def sendSlackMessage(message,status): 
   # Sends a Yo to the user defined in the envrionement variable YO_USER with the 
   # Yo account corresponding to the token defined in the environement variable 
   # YO_TOKEN.
   success = "successfuly" if status==0 else "with errors"
   message = message.replace('&','&amp')
   message = message.replace('<','&lt')
   message = message.replace('>','&gt')
   data = {
      'payload':json.dumps({
         'channel': '@'+user,
         'username': host, 
         'text': 'The following command finished '+success+': `'+message+'`'
      })
   }
   request = urllib.urlopen(url,urllib.urlencode(data))
   res = request.read()
   if not res=='ok': 
      print 'Slack error: "'+res+'"'
   
command = ' '.join(sys.argv[1:]).strip()
# Get the command back
if not command: 
  print "Usage: `sl [command]` where `command` is any command you would run in the terminal"
  sys.exit(1)

host = os.environ.get('HOSTNAME','Command Line Bot').split('.')[0] 
user = os.environ.get('SLACK_USER')
url = os.environ.get('SLACK_URL')

if not user: 
   print "Slack error: SLACK_USER not found"
   sys.exit(1)
if not url: 
   print "Slack error: SLACK_URL not found"
   sys.exit(1)


status = subprocess.call(command,shell=True)
# Execute the command and wait for its execution to finish
sendSlackMessage(command,status)
# Send a slack notification to the slackbot channel once the task is done

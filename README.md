# sl.ack
Receive a slack notification when a shell command is done 

## Examples

This script first executes the command passed as argument, then, when the command 
is done, it sends you a slack notifications through slackbot. 

```
sl ls -al 
sl sleep 10s
sl make
sl ENV_VAR=FOO make 
```

## Configurations 

- SLACK_USER: your slack username
- SLACK_URL: the webhook url you want to use
- HOSTNAME: (optionnal) the name of the host that the script is running from. 

## Installation

1. Copy the `sl` script to ~/sl-ack.py
2. In order to obtain the web hook URL, create an incomming web hook in https://slack.com/apps 
and configure it for the channel @slackbot if you don't want to post on a 
channel but send direct messages to yourself. 
2. In your `.profile` or `.bashrc` depending on your OS, add the following lines: 
```
export SLACK_USER=<your slack user name>                                                      
export SLACK_URL=https://hooks.slack.com/services/<your slack web hook url>
alias sl="python ~/sl-ack.py"      
```
3. run `source ~/.profile` or `source ~/.bashrc`

Alternatively you can just drop the `sl` file in your bin folder and just set the environment variables appropriately. 




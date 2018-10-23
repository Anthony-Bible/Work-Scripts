# Work-Scripts
Scripts that I have found useful in work especially with automation


## txtwire.py

Download a csv file from txtwire.com for a specific client

## Install.bat
This script gets the computer ready for the next user. It starts off by checking the architecture of the computer copies over important configuration files from an always updated location to the correct directory based off the architecture. It also restarts the logging service in case it was stopped for any reason. 

## HailMary.sh
This script is created to work on proxmox 5.1. THis script is intended to automate the switching over process in case of a node failure. In case of a node failure it is important to not spend time on figuring out commands and trying start the servers manually. Some notes, this starts the guests as if it didn't turn off, this means running the script while you have another host running will cause quite a few problems. In addition this script doesn't correct quorum, so if it is expecting more than what is available you will run into errors. 

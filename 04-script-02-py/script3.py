#!/usr/bin/env python3

from math import e
import os
from pydoc import doc
import sys
import socket

#Get hosts names from args. Init host responses list
HOSTS=sys.argv[1:]
hosts_resp=[]
hosts_from_file=[]

#Write head record to log
with open('hosts.log','a') as log:
    log.write('\n'+'======= START TESTING HOSTS =======\n')
#Get hosts info
for host in HOSTS:
    hosts_resp.append((host,socket.gethostbyname(host)))
print(hosts_resp)
#Comparison recieved current IP from hosts with hosts IP's recieved before seved in local file
#Print print results to stdout
if os.path.exists('hosts'):
    with open("hosts", 'r') as hosts_file:
        for host in hosts_file.read().split(' ; '):
            hosts_from_file.append(tuple(host.split(' ')))
    print(hosts_from_file)
    i=0
    while i<len(hosts_resp):
        if hosts_resp[i][1]==hosts_from_file[i][1]:
            text='\nHost name: '+hosts_resp[i][0]+'\r\t\t\t\tIP: '+hosts_resp[i][1]+'\r\t\t\t\t\t\t\tIs OK! Without changes'
        else:
            text='\nHost - '+hosts_resp[i][0]+'\t: IP - '+hosts_resp[i][1]+' differs from the '+hosts_from_file[i][1]+' received earlier!!!'
        i+=1
        print(text)
#Save new hosts data in local file 
with open('hosts','w') as hosts_file:
        hosts=[' '.join(host) for host in hosts_resp]
        hosts_file.write(' ; '.join(hosts))


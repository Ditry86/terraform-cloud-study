#!/usr/bin/env python3

import os, sys
import string
import socket
import yaml, json


#Get hosts names from args. Init host responses list
HOSTS=sys.argv[1:]
#Init disct with hosts list (current hosts info and hosts info saved before for comparison)
hosts_list={'Current':[],'Before':[]}
#Init mark that indicates whether to write to the file
x=0

#Get hosts info
for host in HOSTS:
    hosts_list['Current'].append({'host':host,'IP':socket.gethostbyname(host)})
#Comparison recieved current IP from hosts with hosts IP's recieved before seved in local file "hosts"
#Print print results to stdout
if os.path.exists('hosts') and os.stat('hosts').st_size!=0:
#Read hosts records from file "hosts" and write them to 'Before' item of hosts_list dict
    with open("hosts", 'r') as hosts_file:
        for host in hosts_file.read().split(' ; '):
            items=(host.split(' '))
            hosts_list['Before'].append({'host':items[0],'IP':items[1]})
    i=0
#Compare "Current" and "Before" hosts info lists
    while i<len(hosts_list['Current']):
        if hosts_list['Current'][i]['IP']==hosts_list['Before'][i]['IP']:
            text='\nHost name: '+hosts_list['Current'][i]['host']+'\r\t\t\t\tIP: '+hosts_list['Current'][i]['IP']+'\r\t\t\t\t\t\t\tIs OK! Without changes'
        else:
            text='\nHost - '+hosts_list['Current'][i]['host']+': IP - '+hosts_list['Current'][i]['IP']+' differs from the '+hosts_list['Before'][i]['IP']+' received earlier!!!'
            x=1
        i+=1
        print(text)
else:
    x=1
#Save new hosts data in local file 
if x==1:
    with open('hosts','w') as hosts_file:
            hosts=[host['host']+' '+host['IP'] for host in hosts_list['Current']]
            hosts_file.write(' ; '.join(hosts))
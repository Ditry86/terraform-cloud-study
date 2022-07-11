#!/usr/bin/env python3

from curses import keyname
import os, sys
import socket
import yaml, json


#Init disct with hosts list (current hosts info and hosts info saved before for comparison)
hosts_list={'Current':[],'Before':[]}
#Init mark that indicates whether to write to the file
x=0

#Get key a key that specifies which format to use to save host records and check him
lang=sys.argv[1]
if lang in ('y','yaml','yam','yml'):
    file_name='hosts.yaml'
    lang='yaml'
elif lang in ('json','jsn','js','j'):
    file_name='hosts.json'
    lang='json'
else:
    sys.exit('You entered bad lang key (first arg)')
#Get hosts names from args. Init host responses list
HOSTS=sys.argv[2:]
#Get hosts info
for host in HOSTS:
    hosts_list['Current'].append({host:socket.gethostbyname(host)})
#Comparison recieved current IP from hosts with hosts IP's recieved before seved in local file "hosts"
#Print print results to stdout
if os.path.exists(file_name):
#Read hosts records from file hosts.[json|yaml] file (if it's there) and write them to 'Before' item of hosts_list dict
    if lang=='yaml':
        with open(file_name,'r') as file:
            hosts_list['Before']=yaml.load(file)
    elif lang=='json':
        with open(file_name,'r') as file:
            hosts_list['Before']=json.load(file)
    else:
        sys.exit('Bad param')
    x=1
i=0
if x!=0:
#Compare "Current" and "Before" hosts info lists. Print results
    while i<len(hosts_list['Current']):
        if hosts_list['Current'][i][HOSTS[i]]==hosts_list['Before'][i][HOSTS[i]]:
            text='\n'+HOSTS[i]+'\r\t\t: '+hosts_list['Current'][i][HOSTS[i]]+'\r\t\t\t\t\tIs OK! Without changes'
        else:
            text='\n'+HOSTS[i]+' : '+hosts_list['Current'][i][HOSTS[i]]+'\r\t\t\t\t\tdiffers from the '+hosts_list['Before'][i][HOSTS[i]]+' received earlier!!!'
            x=1
        i+=1
        print(text)
else:
    i=0
    while i<len(hosts_list['Current']):
        text='\n'+hosts_list['Current'][i][HOSTS[i]]+'\r\t\t\tIs OK!'
        print(text)
        i+=1
#Save hosts info to format (yaml,json) file
if lang=='yaml':
    with open(file_name,'w') as file:
        yaml.dump(hosts_list['Current'],file)
elif lang=='json':
    with open(file_name,'w') as file:
        json.dump(hosts_list['Current'],file)

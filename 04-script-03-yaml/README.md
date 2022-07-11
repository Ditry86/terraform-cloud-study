### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "71.75.22.43" 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
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
```

### Вывод скрипта при запуске при тестировании:
```
ditry@work-pc:~/study/devops-netology/04-script-03-yaml$ ./script.py j drive.google.com mail.google.com google.com

drive.google.com: 64.233.162.194        Is OK! Without changes

mail.google.com : 142.251.1.83          differs from the 142.251.1.19 received earlier!!!

google.com      : 192.138.159.3         Is OK! Without changes
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
ditry@work-pc:~/study/devops-netology/04-script-03-yaml$ cat hosts.json 
[{"drive.google.com": "64.233.162.194"}, {"mail.google.com": "142.251.1.83"}, {"google.com": "192.138.159.3"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
ditry@work-pc:~/study/devops-netology/04-script-03-yaml$ cat hosts.yaml 
- drive.google.com: 142.251.1.194
- mail.google.com: 142.251.1.17
- google.com: 192.138.159.3
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???

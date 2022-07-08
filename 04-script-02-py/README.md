### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакой. Переменная с не создается. Интерпретатор python не позволяет сложить две переменные разного типа без их преобразований. |
| Как получить для переменной `c` значение 12?  | c = str(a) + c  |
| Как получить для переменной `c` значение 3?  | c = a + int(b) |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys


path=
bash_command = ["cd "+path, "git status --ignored=no -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = 0
changes=['AM','AD','MD','MM','A','M','D','??']
for result in result_os.split('\n'):
    for x in changes :
        if result.find(x) != -1:
            is_change = x
            break
    if is_change != 0:
        prepare_result = result.replace(is_change+' ', is_change+' '+path)
        print(prepare_result)
        is_change=False
```

### Вывод скрипта при запуске при тестировании:
```
A /home/ditry/study/devops-netology/ 04-script-02-py/123
MM /home/ditry/study/devops-netology/04-script-02-py/script1.py
AD /home/ditry/study/devops-netology/111
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

path=sys.argv[1]
print(path)
bash_command = ["cd "+path, "git status --ignored=no -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = 0
changes=['AM','AD','MD','MM','A','M','D','??']
for result in result_os.split('\n'):
    for x in changes :
        if result.find(x) != -1:
            is_change = x
            break
    if is_change != 0:
        prepare_result = result.replace(is_change+' ', is_change+' '+path)
        print(prepare_result)
        is_change=False

```

### Вывод скрипта при запуске при тестировании:
```
ditry@work-pc:~/study/devops-netology/04-script-02-py$ ./script2.py /home/ditry/study/
/home/ditry/study/
fatal: не найден git репозиторий (или один из родительских каталогов): .git

ditry@work-pc:~/study/devops-netology/04-script-02-py$ ./script2.py /home/ditry/study/devops-netology/
 M /home/ditry/study/devops-netology/04-script-02-py/script1.py
?? /home/ditry/study/devops-netology/04-script-02-py/script2.py
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за   DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
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
#Comparison recieved current IP from hosts with hosts IP's recieved before seved in local file
#Print print results to stdout
if os.path.exists('hosts'):
    with open("hosts", 'r') as hosts_file:
        for host in hosts_file.read().split(' ; '):
            hosts_from_file.append(tuple(host.split(' ')))
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


```

### Вывод скрипта при запуске при тестировании:
```
Host name: drive.google.com     IP: 173.194.221.194     Is OK! Without changes

Host - mail.google.com  : IP - 108.177.14.17 differs from the 108.177.14.19 received earlier!!!

Host - myweb.ru : IP - 127.0.0.3 differs from the 192.138.159.3 received earlier!!!
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```

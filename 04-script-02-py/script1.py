#!/usr/bin/env python3

import os

path="/home/ditry/study/devops-netology"
bash_command = ["cd "+path, "git status -u"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = 0
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        is_change='изменено'
    elif result.find('новый файл') != -1:
        is_change='новый файл'
    elif result.find('удалено') != -1:
        is_change='удалено'
    if is_change != 0:
        prepare_result = result.replace('\t'+is_change+':   ', '\t'+is_change+'/home/ditry/study/devops-netology')
        print(result)
        is_change=False

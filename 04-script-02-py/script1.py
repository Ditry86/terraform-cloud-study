#!/usr/bin/env python3

import os


path="/home/ditry/study/devops-netology/"
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

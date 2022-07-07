### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

---


# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash 
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование                                                                                                                   |
| ------------- |----------|-------------------------------------------------------------------------------------------------------------------------------|
| `c`  | a+b      | bash понимает запись c=a+b как "присвоить переменной c запись символовa+b"                                                    |
| `d`  | 1+2      | bash понимает запись d=$a+$b как "присвоить переменной d запись символовов значений переменных a,b и символа + |
| `e`  | 3        | здесь bash присваивает переменной e результат вычисления операции + со значениями переменных а и b                            |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:
```bash
while ((1==1))
do
        curl https://localhost:4757 >> /dev/null
        if (($?==0))
        then
                break
        fi
        date >> curl.log
done



```

## Обязательная задача 3
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
echo $(date -u) > curl1.log
addr=(192.168.0.1 173.194.222.113 87.250.250.242)
echo "I working..."
for k in ${addr[@]}
do
        echo $'\n'$k >> curl1.log
        echo "========================" >> curl1.log
        i=0
        while (($i<5))
        do
                echo $'\n'Try $(($i+1)) >> curl1.log
                curl -s -m 3 $k:80 >> /dev/null
                echo Response code - $? >> curl1.log
                ((i+=1))
        done
        echo >> curl1.log
done
echo "Done"

```

## Обязательная задача 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
echo $(date -u) > curl2.log
addr=(192.168.0.1 173.194.222.113 87.250.250.242)
echo "I working..."
for k in ${addr[@]}
do
        echo $'\n'$k >> curl2.log
        echo "========================" >> curl2.log
        i=0
        while (($i<5))
        do
                echo "$'\n'Try $(($i+1))" >> curl2.log
                curl -s -m 3 $k:80 >> /dev/null
                e=$?
                echo "Response code - $e" >> curl2.log
                if (($e!=0))
                then
                        echo $(date -u) >> error.log
                        echo "Node - $k. Trying $(($i+1)). Breaking with error code - $e" >> error.log
                        break
                fi
                ((i+=1))
        done
        if (($e!=0))
        then
                break
        fi
        echo $'\n' >> curl2.log
done
echo "Done"
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
regex="\[04\-script\-01\-bash\].{0,11}"
error_msg="Aborting commit. Your commit message is missing regex"

if ! grep -iqE "$regex" "$1"; then
    echo "$error_msg" >&2
    exit 1
fi


```
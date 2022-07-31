# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---


## Важно!

Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это важно для того, чтоб предупредить неконтролируемый расход средств, полученных в результате использования промокода.

Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md)

---

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

### **Ответ**

- Replication предпологает репликацию сервисов на определенное количество нод. Global в свою очереть означает репликацию сервисов на все ноды кластера, в том числе и ноды manager.
- RAFT (алгоритм получения консенсуса в распределенных системах, и одноименный протокол).
- Сеть поверх другой сети. В Docker используется для связи между контейнерами в кластерах swarm, точнее для связи и работы сервисов в этих контейнерах в сети, раздельной от хостов, на которых эти контейнеры запущены. Аналог vpn, строится на базе vxlan. Инкапсулирует фреймы 2-го уровня (ethernet) overlay сети нод swarm в пакеты 3-го уровня (tcp/ip) сети хостов. Тем самым, запущенные в кластере swarm контейнеры работают в одной своей локальной сети с адним адресным пространством, поверх реальных соединений хостов, которые могут быть в разных сетях.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

### **Ответ**

```
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
u5w4ag5nevd13wnxyugntodtu *   node01.netology.yc   Ready     Active         Leader           20.10.17
3vl5xlrzbsmt4fef72ki7f64u     node02.netology.yc   Ready     Active         Reachable        20.10.17
xh1mmhinttnpwmcvujju7yl3v     node03.netology.yc   Ready     Active         Reachable        20.10.17
ozxouzybdmmbah1pmelqxau1e     node04.netology.yc   Ready     Active                          20.10.17
lr57vqu0tp56incz1p6g24rb4     node05.netology.yc   Ready     Active                          20.10.17
rcqnzwaqzsaj5azrnptpo209g     node06.netology.yc   Ready     Active                          20.10.17
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

### **Ответ**

```
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
siex8e4wydqf   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
v6wna1on0l1g   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
280zh0qyf2za   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
0cu4ronggoiw   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
x4lr7z7xhgya   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
2uy84ad9g18n   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
inun9j643exo   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
qb3matojri0j   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

### **Ответ**

Команда позволяет блокировать (шифровать) ключи, используемые для шифрациия и дешифрации сообщений RAFT между manager нодами, а так же ключи шифрации логов на manager нодах. Разблокировка возможна вручную, и соответственно перезапуск (запуск) нод так же должен производиться вручную с предоставлением ключа для разбокировки
Сделано это для увеличения безопасности использования кластера swarm. При этом необходимо менять ключи шифровки перед каждыми перезапусом нод. 
Для автоматической развертке это позволяет избежать проблем при перезагруке, запуске кластера в случае просроченных сертификатов ключей.
# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### **Ответ**

```
docker-compose -f postresql.yaml build
```
Docker-compose манифест - [Ссылка](./postgresql.yaml)


## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### **Ответ:**


- Список БД:
```
# \l
                                      List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |        Access privileges        
-----------+----------+----------+------------+------------+---------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                   +
           |          |          |            |            | postgres=CTc/postgres          +
           |          |          |            |            | "test-simple-user"=CTc/postgres
(4 rows)
```

- Список таблиц БД test_db:
```
# \d
               List of relations
 Schema |      Name      |   Type   |  Owner   
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)
```

- SQL-запрос и полученный список пользователей с правами над таблицами test_db:

```
# SELECT table_name, grantee, privilege_type 
FROM (SELECT * FROM information_schema.role_table_grants WHERE grantee NOT IN ('postgres','PUBLIC')) AS sel_rol
WHERE table_catalog = 'test_db';

 table_name |     grantee      | privilege_type 
------------+------------------+----------------
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
(22 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

### **Ответ**

- SQL-запросы:

```
# INSERT INTO orders VALUES
(DEFAULT,'Шоколад',10),
(DEFAULT,'Принтер',3000),
(DEFAULT,'Книга',500),
(DEFAULT,'Монитор',7000),
(DEFAULT,'Гитара',4000);

# INSERT INTO clients (customer, country) VALUES
('Иванов Иван Иванович','USA'),
('Петров Петр Петрович','Canada'),
('Иоганн Себастьян Бах','Japan'),
('Ронни Джеймс Дио','Russia'),
('Ritchie Blackmore','Russia');
```

- Результаты:

```
SELECT * FROM orders;
 id |  name   | price 
----+---------+------
  1 | Шоколад |    10
  3 | Шоколад |    10
  4 | Принтер |  3000
  5 | Книга   |   500
  6 | Монитор |  7000
  7 | Гитара  |  4000
(6 rows)
```

- Количество записей:

```
# SELECT COUNT(*) FROM orders;
 count 
-------
     6
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

### **Ответ:**

1)
```
#UPDATE clients SET orders=(SELECT id FROM orders WHERE name='Книга') WHERE customer='Иванов Иван Иванович';
```

2)

```
#SELECT * FROM clients WHERE orders IS NOT NULL;

id | orders |       customer       | country 
----+--------+----------------------+---------
  2 |     11 | Петров Петр Петрович | Canada
  1 |     10 | Иванов Иван Иванович | USA
  3 |     12 | Иоганн Себастьян Бах | Japan
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### **Ответ:**

```
# explain analyze verbose select * from clients;
                                                 QUERY PLAN                                                 
------------------------------------------------------------------------------------------------------------
 Seq Scan on public.clients  (cost=0.00..18.10 rows=810 width=72) (actual time=0.024..0.027 rows=5 loops=1)
   Output: id, orders, customer, country
 Planning Time: 4.279 ms
 Execution Time: 0.455 ms
(4 rows)
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

### **Ответ:**
```
postgresql# pg_dumpall -U postgres > /tmp/postgresql.back
# docker stop postgresql
# docker-compose -f posgresql1.yaml up -d
# docker exec -ti posgresql_2 bash
postgresql_2# psql -U postgres -f /tmp/postgresql.back postgres
postgresql_2# select * from clients where orders is not null;

 id | orders |       customer       | country 
----+--------+----------------------+---------
  2 |     11 | Петров Петр Петрович | Canada
  1 |     10 | Иванов Иван Иванович | USA
  3 |     12 | Иоганн Себастьян Бах | Japan
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

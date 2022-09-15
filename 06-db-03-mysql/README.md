# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### **Ответ:**

```
mysql> STATUS
...
Server version:         8.0.30 MySQL Community Server - GPL

mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| clients           |
| orders            |
+-------------------+
2 rows in set (0.01 sec)

mysql> SHOW COLUMNS FROM orders;
+-------+-----------------+------+-----+---------+----------------+
| Field | Type            | Null | Key | Default | Extra          |
+-------+-----------------+------+-----+---------+----------------+
| id    | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| title | varchar(80)     | NO   |     | NULL    |                |
| price | int             | YES  |     | NULL    |                |
+-------+-----------------+------+-----+---------+----------------+
3 rows in set (0.01 sec)

mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### **Ответ:**

```
mys``l> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test'; 
+------+------+--------------------------------------+
| USER | HOST | ATTRIBUTE                            |
+------+------+--------------------------------------+
| test | %    | {"name": "James", "fname": "Pretty"} |
+------+------+--------------------------------------+
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### **Ответ:**

```
mysql> SELECT table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| clients    | InnoDB |
| orders     | InnoDB |
+------------+--------+
...
mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00074750 | SELECT table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'test_db' |
|        2 | 0.02596850 | alter table orders engine = 'MyISAM'                                                    |
|        3 | 0.02057700 | alter table clients engine = 'MyISAM'                                                   |
|        4 | 0.00086150 | SELECT table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'test_db' |
|        5 | 0.03037825 | alter table orders engine = 'InnoDB'                                                    |
|        6 | 0.03919850 | alter table clients engine = 'InnoDB'                                                   |
|        7 | 0.00096525 | SELECT table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'test_db' |
+----------+------------+-----------------------------------------------------------------------------------------+
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### **Ответ:**

My.cnf файл - [Ссылка](./my.cnf)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
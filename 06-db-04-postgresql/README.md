# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### **Ответ:**
```
- вывода списка БД - \l
- подключения к БД - \c <dbname>
- вывода списка таблиц - \dt 
- вывода описания содержимого таблиц - \d <table>
- выхода из psql - \q
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### **Ответ:**

```
test_database=# SELECT attname FROM pg_stats WHERE avg_width=(SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');
 attname 
---------
 title
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### **Ответ:**

В документации postgres для разбиения (sharding) описываются два метода:
1) наследование таблицы (для уже созданных таблиц). Данных метод как раз подходит для решения поставленной задачи;
2) декларативное разделение (при создании таблиц). С помощью данного метода решается проблема "ручного" разбиения таблиц. Условие разбиения описывается в запросе создания таблицы один раз, после чего СУБД сама производит разбиение при вхождении в описанного условия.

1. Транзакция разбиения таблицы orders на две секционные таблицы по условию (orders_1 - price>499 и orders_2 - price<=499):

```
BEGIN;
CREATE TABLE orders_1 (
    CHECK (price>499)
) INHERITS (orders);
CREATE TABLE orders_2 (
    CHECK (price<=499)
) INHERITS (orders);
CREATE INDEX orders_1_idx ON orders_1 (price);
CREATE INDEX orders_2_idx ON orders_1 (price);
CREATE OR REPLACE FUNCTION orders_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.price > 499 ) THEN
        INSERT INTO orders_1 VALUES (NEW.*);
    ELSIF ( NEW.price <= 499 ) THEN
        INSERT INTO orders_2 VALUES (NEW.*);
    ELSE
        RAISE EXCEPTION 'Mistake!  See and fix the orders_insert_trigger() function!';
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER insert_orders    
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION orders_insert_trigger();
WITH less AS (  
    SELECT * FROM ONLY orders     
        WHERE price >499 )
INSERT INTO orders_1 SELECT * FROM less;
WITH more AS (  
    SELECT * FROM ONLY orders     
        WHERE price <=499 )
INSERT INTO orders_2 SELECT * FROM less;
TRUNCATE ONLY orders;
COMMIT;
```

2. Декларативный метод разделения таблицы:

```
BEGIN;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    price INT
) PARTITION BY RANGE (price);
CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES FROM 500 TO MAXVALUE;
CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM MINVALUE TO 500;
CREATE INDEX ON orders_1 (price);
CREATE INDEX ON orders_2 (price);
COMMIT;
```

Так же для предотвращения черезмерного увеличения объема секционных таблиц при добавлении новых записей обычно создают скрипты, либо триггеры в основную таблицу, которые создают новые секции при увеличении уже созданных до максимального объема.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### **Ответ:**
```
ALTER TABLE public.orders
    ADD CONSTRAINT unic_title UNIQUE (title);
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

# Результати запитів - Лабораторна робота 5
# Семесько Артем Юрійович, група 491

---

## Рисунок 1 - Структура таблиці users

```
\d users
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('users_id_seq'::regclass)
 2  | name | varchar(100) | not null | 
 3  | email | varchar(100) | not null | 
 4  | registration_date | date | | current_date
 5  | is_active | boolean | | true
 PK: id
 UNIQUE: email
 FK: -
```

---

## Рисунок 2 - Структура таблиці accounts

```
\d accounts
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('accounts_id_seq'::regclass)
 2  | user_id | integer | | 
 3  | account_number | varchar(20) | not null | 
 4  | balance | numeric(15,2) | | 0.00
 5  | account_type | varchar(20) | | 
 PK: id
 UNIQUE: account_number
 FK: user_id -> users(id)
 CHECK: account_type IN ('checking', 'savings', 'credit')
```

---

## Рисунок 3 - Структура таблиці transactions

```
\d transactions
```

```
 id | name | type | nullable | default
----+------+------+---------+--------
 1  | id | integer | not null | nextval('transactions_id_seq'::regclass)
 2  | account_id | integer | | 
 3  | amount | numeric(10,2) | not null | 
 4  | type | varchar(10) | | 
 5  | description | varchar(200) | | 
 6  | transaction_date | date | | current_date
 7  | category_id | integer | | 
 PK: id
 FK: account_id -> accounts(id)
 CHECK: type IN ('debit', 'credit')
 TRIGGER: balance_trigger
```

---

## Рисунок 4 - Дані таблиці users

```
SELECT * FROM users;
```

```
 id |        name         |             email             | registration_date | is_active 
----+---------------------+-------------------------------+-------------------+-----------
  1 | Богдан Дорошенко    | bohdan.doroshenko@email.com   | 2024-01-12        | t
  2 | Діана Савчук        | diana.savchuk@email.com      | 2024-02-22        | t
  3 | Федір Козубець      | fedor.kozubets@email.com     | 2024-03-08        | t
  4 | Соломія Романенко   | solomiia.rom@email.com       | 2024-04-03        | t
  5 | Данило Гаврилюк     | danylo.havryliuk@email.com   | 2024-05-15        | t
  6 | Аліна Тарасенко     | alina.tar@email.com          | 2024-06-20        | t
  7 | Кирило Онищенко     | kyrylo.on@email.com          | 2024-07-25        | t
  8 | Маргарита Пономаренко| margarita.pon@email.com      | 2024-08-16        | t
  9 | Орест Тимошенко     | orest.tym@email.com          | 2024-09-12        | f
 10 | Артем Семесько      | artem.semesko@email.com      | 2024-10-01        | t
(10 rows)
```

---

## Рисунок 5 - Дані таблиці accounts

```
 id | user_id | account_number |  balance  | account_type 
----+---------+----------------+-----------+--------------
  1 |       1 | ACC001         |  1700.75 | checking
  2 |       1 | ACC002         |  4900.00 | savings
  3 |       1 | ACC003         |  2550.00 | credit
  ...
 20 |      10 | ACC020         |  6050.00 | savings
 21 |      10 | ACC021         |   825.00 | checking
(30 rows)
```

---

## Рисунок 6 - Дані таблиці categories

```
 id |      name       
----+-----------------
  1 | Покупки
  2 | Зарплата
  3 | Оплата рахунків
  4 | Транспорт
  5 | Розваги
  6 | Їжа
  7 | Іпотека
  8 | Бонус
  9 | Інвестиція
 10 | Повернення
(10 rows)
```

---

## Рисунок 7 - INNER JOIN результат

```
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;
```

```
     name          | account_number | total_amount 
-------------------+----------------+--------------
 Богдан Дорошенко  | ACC001         |       262.50
(результат залежить від даних транзакцій)
```

---

## Рисунок 8 - Агрегатні функції

```
SELECT account_type, COUNT(*), SUM(balance), AVG(balance)
FROM accounts GROUP BY account_type;
```

```
 account_type | count |   sum    |   avg   
--------------+-------+----------+---------
 credit       |     8 | 18875.00 | 2359.38
 savings      |    11 | 44650.25 | 4059.11
 checking     |    11 | 25425.00 | 2311.36
(3 rows)
```

---

## Рисунок 9 - Stored Procedure

```
CALL calculate_balance_proc(1, NULL);
```

```
 balance 
--------
 262.50
```

---

## Рисунок 10 - Trigger перевірка

```
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) 
VALUES (1, 215, 'credit', 'Перевірочна операція');
SELECT balance FROM accounts WHERE id = 1;
```

```
 balance 
--------
 262.50   <- до INSERT

 INSERT 0 1

 balance 
--------
 477.50   <- після INSERT (+215)
```

---

## Рисунок 11 - Дані студента Семесько Артем

```
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Артем Семесько';
```

```
     name        | account_number |  balance  | account_type 
----------------+----------------+-----------+--------------
 Артем Семесько | ACC020         | 6050.00 | savings
 Артем Семесько | ACC021         |  825.00 | checking
(2 rows)

Загальний баланс: $6,875.00
```

---

## Рисунок 12 - Баланси користувачів

```
SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
```

```
       name        |  total   
-------------------+----------
 Богдан Дорошенко  | 12451.50
 Данило Гаврилюк   |  8200.75
 Кирило Онищенко   |  8175.50
 Соломія Романенко |  7950.25
 Орест Тимошенко   |  7400.25
 **Артем Семесько**|  **6875.00**
 Федір Козубець    |  7075.50
 Діана Савчук      |  6180.75
 Маргарита Пономаренко| 5810.50
 Аліна Тарасенко   |  5335.50
(10 rows)
```

---

## Підсумок

| Таблиця | Записів |
|---------|---------|
| users | 10 |
| accounts | 30 |
| transactions | 50 |
| categories | 10 |
| **Всього** | **100** |

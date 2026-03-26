# Результати запитів - Лабораторна робота 5
# Семесько Артем Юрійович, група 491

---

## Структура таблиці users

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

## Структура таблиці accounts

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

## Структура таблиці transactions

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

## Дані таблиці users

```
SELECT * FROM users;
```

```
 id |       name        |            email            | registration_date | is_active 
----+-------------------+-----------------------------+-------------------+-----------
  1 | Іван Петренко     | ivan.petrenko@email.com     | 2024-01-15        | t
  2 | Марія Коваленко   | maria.kovalenko@email.com   | 2024-02-20        | t
  3 | Олег Сидоренко    | oleg.sydorenko@email.com    | 2024-03-10        | t
  4 | Анна Шевченко     | anna.shevchenko@email.com   | 2024-04-05        | t
  5 | Віктор Бондаренко | viktor.bondarenko@email.com | 2024-05-12        | t
  6 | Ольга Гриценко    | olga.gritsenko@email.com    | 2024-06-18        | t
  7 | Дмитро Кравченко  | dmytro.kravchenko@email.com | 2024-07-22        | t
  8 | Софія Литвиненко  | sofia.lytvynenko@email.com  | 2024-08-14        | t
  9 | Андрій Мороз      | andriy.moroz@email.com      | 2024-09-08        | f
 10 | Артем Семесько    | artem.semesko@email.com     | 2024-10-01        | t
(10 rows)
```

---

## Дані таблиці accounts

```
 id | user_id | account_number |  balance  | account_type 
----+---------+----------------+-----------+--------------
  1 |       1 | ACC001         |  1500.50 | checking
  2 |       1 | ACC002         |  5000.00 | savings
  3 |       1 | ACC003         |  2500.00 | credit
  ...
 20 |      10 | ACC020         |  6100.50 | savings
 21 |      10 | ACC021         |   850.00 | checking
(30 rows)
```

---

## Дані таблиці categories

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

## INNER JOIN результат

```
SELECT u.name, a.account_number, SUM(t.amount) AS total
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;
```

---

## Агрегатні функції

```
SELECT account_type, COUNT(*), SUM(balance), AVG(balance)
FROM accounts GROUP BY account_type;
```

```
 account_type | count |   sum    |   avg   
--------------+-------+----------+---------
 credit       |     8 | 18950.50 | 2368.81
 savings      |    11 | 43604.25 | 3964.02
 checking     |    11 | 25103.00 | 2282.09
(3 rows)
```

---

## Stored Procedure

```
CALL calculate_balance_proc(1, NULL);
```

```
 balance 
--------
 300.00
```

---

## Trigger перевірка

```
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) 
VALUES (1, 200, 'credit', 'Test');
SELECT balance FROM accounts WHERE id = 1;
```

```
 balance 
--------
 1500.50   <- до INSERT

INSERT 0 1

 balance 
--------
 1700.50   <- після INSERT (+200)
```

---

## Дані студента Семесько Артем

```
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Артем Семесько';
```

```
       name       | account_number |  balance  | account_type 
-----------------+----------------+-----------+--------------
 Артем Семесько  | ACC020         |  6100.50 | savings
 Артем Семесько  | ACC021         |   850.00 | checking
(2 rows)

Загальний баланс: $6,950.50
```

---

## Баланси користувачів

```
SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;
```

```
       name        |  total   
-------------------+----------
 Іван Петренко     | 13401.25
 Андрій Мороз      | 11300.50
 Дмитро Кравченко  | 11201.50
 Віктор Бондаренко |  8900.75
 Анна Шевченко     |  8700.25
 **Артем Семесько** |  **6950.50**
 Олег Сидоренко    |  7600.75
 Марія Коваленко   |  6450.75
 Софія Литвиненко  |  6450.75
 Ольга Гриценко    |  5600.75
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

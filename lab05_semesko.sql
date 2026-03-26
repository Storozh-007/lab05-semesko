-- База даних: financial_database_semesko
-- Семесько Артем Юрійович, група 491
-- Лабораторна робота 5: SQL, PL/pgSQL, тригери

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    account_type VARCHAR(20) CHECK (account_type IN ('checking', 'savings', 'credit'))
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(id),
    amount DECIMAL(10,2) NOT NULL,
    type VARCHAR(10) CHECK (type IN ('debit', 'credit')),
    description VARCHAR(200),
    transaction_date DATE DEFAULT CURRENT_DATE,
    category_id INTEGER
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

ALTER TABLE transactions ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES categories(id);

INSERT INTO users (name, email, registration_date, is_active) VALUES
('Богдан Дорошенко','bohdan.doroshenko@email.com','2024-01-12',TRUE),
('Діана Савчук','diana.savchuk@email.com','2024-02-22',TRUE),
('Федір Козубець','fedor.kozubets@email.com','2024-03-08',TRUE),
('Соломія Романенко','solomiia.rom@email.com','2024-04-03',TRUE),
('Данило Гаврилюк','danylo.havryliuk@email.com','2024-05-15',TRUE),
('Аліна Тарасенко','alina.tar@email.com','2024-06-20',TRUE),
('Кирило Онищенко','kyrylo.on@email.com','2024-07-25',TRUE),
('Маргарита Пономаренко','margarita.pon@email.com','2024-08-16',TRUE),
('Орест Тимошенко','orest.tym@email.com','2024-09-12',FALSE),
('Артем Семесько','artem.semesko@email.com','2024-10-01',TRUE);

INSERT INTO accounts (user_id, account_number, balance, account_type) VALUES
(1,'ACC001',1700.75,'checking'),(1,'ACC002',4900.00,'savings'),(1,'ACC003',2550.00,'credit'),
(2,'ACC004',850.00,'checking'),(2,'ACC005',1300.25,'savings'),
(3,'ACC006',3450.25,'checking'),(3,'ACC007',2750.75,'credit'),
(4,'ACC008',925.00,'savings'),
(5,'ACC009',2150.50,'credit'),(5,'ACC010',4450.25,'savings'),(5,'ACC011',675.75,'checking'),
(6,'ACC012',1375.00,'savings'),(6,'ACC013',950.25,'checking'),
(7,'ACC014',3050.00,'credit'),(7,'ACC015',700.00,'savings'),(7,'ACC016',1575.50,'checking'),
(8,'ACC017','ACX017',2950.25,'credit'),(8,'ACC018',1025.00,'savings'),
(9,'ACC019',5250.00,'checking'),
(10,'ACC020',6050.00,'savings'),(10,'ACC021',825.00,'checking'),
(1,'ACC022',1875.25,'savings'),(2,'ACC023',3275.00,'credit'),
(3,'ACC024',1125.75,'checking'),(4,'ACC025',5650.00,'savings'),
(5,'ACC026',350.00,'credit'),(6,'ACC027',2075.50,'checking'),
(7,'ACC028',3575.00,'savings'),(8,'ACC029',1225.25,'credit'),
(9,'ACC030',6150.00,'checking');

INSERT INTO categories (name) VALUES
('Покупки'),('Зарплата'),('Оплата рахунків'),('Транспорт'),('Розваги'),
('Їжа'),('Іпотека'),('Бонус'),('Інвестиція'),('Повернення');

INSERT INTO transactions (account_id, amount, type, description, transaction_date) VALUES
(1,105.00,'debit','Продукти на тиждень','2024-11-01'),(1,530.00,'credit','Зарплата листопад','2024-11-05'),
(2,225.00,'debit','Інтернет та телефон','2024-11-09'),
(3,160.00,'debit','Проїздний квиток','2024-11-14'),
(5,270.00,'debit','Ігри PS Plus','2024-11-19'),(5,330.00,'credit','Банківські відсотки','2024-11-24'),
(9,420.00,'debit','Орендна плата','2024-11-10'),(9,590.00,'credit','Бонус за результат','2024-11-15'),
(9,82.00,'debit','Обід','2024-11-17'),(9,155.00,'credit','Cashback','2024-11-21'),
(9,205.00,'debit','Навчальні матеріали','2024-11-27'),
(10,78.00,'debit','Кава','2024-11-02'),(10,375.00,'credit','P2P інвестиція','2024-11-13'),
(10,110.00,'debit','Курси програмування','2024-11-19'),
(11,130.00,'debit','Навушники','2024-11-17'),
(14,92.00,'debit','Пальто','2024-11-01'),(14,305.00,'credit','Повернення товару','2024-11-06'),
(15,118.00,'debit','Спортзал','2024-11-08'),(15,355.00,'credit','Фріланс','2024-11-13'),
(15,72.00,'debit','Лекція','2024-11-18'),
(17,142.00,'debit','Відпочинок','2024-11-02'),(17,465.00,'credit','Акції компанії','2024-11-07'),
(17,98.00,'debit','Підручники','2024-11-11'),(17,335.00,'credit','Продаж речей','2024-11-16'),
(20,148.00,'debit','Розваги','2024-11-21'),(20,495.00,'credit','Відсотки від депозиту','2024-11-26'),
(22,108.00,'debit','Університет','2024-11-03'),(22,350.00,'credit','Робота вихідного дня','2024-11-08'),
(22,168.00,'debit','Кафе з друзями','2024-11-12'),
(25,88.00,'debit','Перекус','2024-11-22'),(25,285.00,'credit','Компенсація','2024-11-27'),
(27,128.00,'debit','Кросівки','2024-11-04'),(27,455.00,'credit','Зарплата','2024-11-09'),
(27,148.00,'debit','Йога','2024-11-11'),
(29,168.00,'debit','Кіно','2024-11-23'),(29,595.00,'credit','Крипто стейкінг','2024-11-28'),
(30,188.00,'debit','Туризм вихідного дня','2024-11-05'),(30,615.00,'credit','Продаж на барахолці','2024-11-10'),
(30,208.00,'debit','Концерт','2024-11-13'),
(1,228.00,'debit','Автобус','2024-11-24'),
(2,248.00,'debit','Бакалія','2024-11-06'),
(3,268.00,'debit','Онлайн курс','2024-11-14'),
(5,288.00,'debit','Чай і тістечка','2024-11-25'),
(7,308.00,'debit','Аксесуари','2024-11-07'),
(10,328.00,'debit','Гантелі','2024-11-15'),
(14,348.00,'debit','Білет в цирк','2024-11-26'),
(15,368.00,'debit','Поїздка','2024-11-09'),
(17,388.00,'debit','Магнітик','2024-11-17'),
(20,408.00,'debit','Ігри','2024-11-27'),
(22,428.00,'credit','Подарунок на день народження','2024-11-29');

UPDATE transactions SET category_id = CASE
    WHEN description ILIKE '%зарплат%' THEN (SELECT id FROM categories WHERE name='Зарплата')
    WHEN description ILIKE '%іпотек%' OR description ILIKE '%орендн%' THEN (SELECT id FROM categories WHERE name='Іпотека')
    WHEN description ILIKE '%бонус%' OR description ILIKE '%результ%' OR description ILIKE '%cashback%' OR description ILIKE '%компенсац%' THEN (SELECT id FROM categories WHERE name='Бонус')
    WHEN description ILIKE '%інвест%' OR description ILIKE '%акці%' OR description ILIKE '%крипто%' OR description ILIKE '%p2p%' OR description ILIKE '%стейкінг%' THEN (SELECT id FROM categories WHERE name='Інвестиція')
    WHEN description ILIKE '%повернен%' THEN (SELECT id FROM categories WHERE name='Повернення')
    WHEN description ILIKE '%їж%' OR description ILIKE '%обід%' OR description ILIKE '%кава%' OR description ILIKE '%кафе%' OR description ILIKE '%бакалія%' OR description ILIKE '%перекус%' OR description ILIKE '%тістечк%' THEN (SELECT id FROM categories WHERE name='Їжа')
    WHEN description ILIKE '%транспорт%' OR description ILIKE '%проїздн%' OR description ILIKE '%автобус%' THEN (SELECT id FROM categories WHERE name='Транспорт')
    WHEN description ILIKE '%інтернет%' OR description ILIKE '%телефон%' THEN (SELECT id FROM categories WHERE name='Оплата рахунків')
    WHEN description ILIKE '%покуп%' OR description ILIKE '%навушники%' THEN (SELECT id FROM categories WHERE name='Покупки')
    ELSE (SELECT id FROM categories WHERE name='Розваги')
END;

-- Базові SELECT
SELECT * FROM transactions WHERE account_id = 1;
SELECT * FROM transactions WHERE account_id = 9 ORDER BY transaction_date DESC;
SELECT * FROM transactions WHERE account_id = 20 AND type = 'credit';

-- Сортування
SELECT * FROM transactions ORDER BY transaction_date DESC;
SELECT * FROM transactions ORDER BY amount DESC, transaction_date;

-- INNER JOIN
SELECT u.name, a.account_number, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name, a.account_number;

-- LEFT JOIN
SELECT u.name, a.account_number
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id
LEFT JOIN transactions t ON a.id = t.account_id
WHERE t.id IS NULL;

-- CROSS JOIN
SELECT u.name, t.description, t.amount
FROM users u
CROSS JOIN transactions t
LIMIT 12;

-- FULL OUTER JOIN
SELECT a.account_number, t.id AS transaction_id, t.amount
FROM accounts a
FULL OUTER JOIN transactions t ON a.id = t.account_id;

-- Агрегатні функції
SELECT account_type, SUM(balance) AS sum_balance FROM accounts GROUP BY account_type;
SELECT account_type, AVG(balance) AS avg_balance FROM accounts GROUP BY account_type;
SELECT type, COUNT(*) AS txn_count, SUM(amount) AS sum_amount FROM transactions GROUP BY type;

-- Оновлення
UPDATE accounts SET balance = balance + 1050 WHERE account_type = 'savings';
SELECT account_number, balance FROM accounts WHERE account_type = 'savings';

UPDATE accounts a SET balance = a.balance + 55
FROM users u
WHERE a.user_id = u.id AND u.is_active = TRUE;
SELECT a.account_number, a.balance
FROM accounts a JOIN users u ON a.user_id = u.id
WHERE u.is_active = TRUE;

-- Видалення
DELETE FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';
SELECT * FROM transactions WHERE transaction_date < CURRENT_DATE - INTERVAL '60 days';

DELETE FROM transactions USING accounts
WHERE transactions.account_id = accounts.id AND accounts.balance < 0;
SELECT a.account_number, a.balance FROM accounts a WHERE a.balance < 0;

-- Підзапити
SELECT a.account_number, SUM(t.amount) AS total_amount
FROM accounts a JOIN transactions t ON a.id = t.account_id
GROUP BY a.account_number
ORDER BY total_amount DESC
LIMIT 4;

SELECT u.name, SUM(t.amount) AS total_amount
FROM users u
JOIN accounts a ON u.id = a.user_id
JOIN transactions t ON a.id = t.account_id
GROUP BY u.name
HAVING SUM(t.amount) > 210;

SELECT t.id, a.account_number, t.amount, t.type, c.name AS category, t.description, t.transaction_date
FROM transactions t
JOIN accounts a ON t.account_id = a.id
LEFT JOIN categories c ON t.category_id = c.id
ORDER BY t.id;

SELECT c.id, c.name
FROM categories c
WHERE (SELECT COALESCE(SUM(t.amount),0) FROM transactions t WHERE t.category_id = c.id) > 110;

-- Stored Procedure
CREATE OR REPLACE PROCEDURE calculate_balance_proc(p_account_id INT, OUT balance DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    SELECT COALESCE(SUM(CASE WHEN type='credit' THEN amount ELSE -amount END),0)
    INTO balance
    FROM transactions t
    WHERE t.account_id = p_account_id;
END;
$$;

CALL calculate_balance_proc(1, NULL);

-- Trigger
CREATE OR REPLACE FUNCTION update_balance() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE accounts
        SET balance = balance + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE accounts
        SET balance = balance
            - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
            + (CASE WHEN NEW.type='credit' THEN NEW.amount ELSE -NEW.amount END)
        WHERE id = NEW.account_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE accounts
        SET balance = balance - (CASE WHEN OLD.type='credit' THEN OLD.amount ELSE -OLD.amount END)
        WHERE id = OLD.account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS balance_trigger ON transactions;
CREATE TRIGGER balance_trigger
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_balance();

-- Тест trigger
SELECT balance FROM accounts WHERE id = 1;
INSERT INTO transactions (account_id, amount, type, description) VALUES (1, 215.00, 'credit', 'Перевірочна операція');
SELECT balance FROM accounts WHERE id = 1;

-- Звіт
SELECT u.name, a.account_number, a.balance, a.account_type
FROM users u JOIN accounts a ON u.id = a.user_id
WHERE u.name = 'Артем Семесько';

SELECT u.name, SUM(a.balance) as total
FROM users u JOIN accounts a ON u.id = a.user_id
GROUP BY u.name ORDER BY total DESC;

BEGIN;

INSERT INTO accounts (user_id, account_number, balance, currency, account_type)
VALUES (1, 'KZ000000000000000009', 50000.00, 'KZT', 'checking');

UPDATE accounts 
SET balance = balance + 10000.00
WHERE account_number = 'KZ000000000000000009';

COMMIT;
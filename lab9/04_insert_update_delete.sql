BEGIN;

INSERT INTO transactions (from_account_id, to_account_id, amount, transaction_type, description)
VALUES (1, 2, 15000.00, 'transfer', 'Monthly salary transfer');

UPDATE accounts 
SET balance = balance - 15000.00
WHERE account_id = 1;

UPDATE accounts 
SET balance = balance + 15000.00
WHERE account_id = 2;

DELETE FROM audit_logs 
WHERE user_id = 1 AND action LIKE 'failed_login%';

COMMIT;
BEGIN;

UPDATE accounts 
SET balance = balance - 5000.00
WHERE account_id = 1;

UPDATE accounts 
SET balance = balance + 5000.00
WHERE account_id = 2;

ROLLBACK;
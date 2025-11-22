BEGIN;
UPDATE accounts SET balance = balance + 20000.00 WHERE account_id = 3;
COMMIT;

BEGIN;
UPDATE accounts SET balance = balance - 5000.00 WHERE account_id = 3;
COMMIT;
BEGIN;

INSERT INTO cards (account_id, card_number, cvc, expiration_date, card_type)
VALUES (1, '1234567890123456', '123', '2025-12-31', 'debit');

SAVEPOINT card_created;

UPDATE cards 
SET card_type = 'credit'
WHERE card_number = '1234567890123456';

ROLLBACK TO SAVEPOINT card_created;

COMMIT;
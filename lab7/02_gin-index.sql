ALTER TABLE transactions ADD COLUMN tags TEXT[];

UPDATE transactions 
SET tags = ARRAY['transfer', 'domestic'] 
WHERE transaction_type = 'transfer';

UPDATE transactions 
SET tags = ARRAY['payment', 'utility'] 
WHERE transaction_type = 'payment';

UPDATE transactions 
SET tags = ARRAY['withdrawal', 'cash'] 
WHERE transaction_type = 'withdrawal';

CREATE INDEX idx_transactions_tags ON transactions USING GIN (tags);

SELECT transaction_id, amount, transaction_type, tags
FROM transactions
WHERE tags @> ARRAY['transfer'];
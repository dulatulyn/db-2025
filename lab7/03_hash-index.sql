CREATE INDEX idx_accounts_account_number ON accounts USING HASH (account_number);

SELECT account_id, account_number, balance, currency
FROM accounts
WHERE account_number = 'KZ000000000000000001';
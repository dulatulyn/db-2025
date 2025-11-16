DROP VIEW IF EXISTS user_accounts_view;

CREATE OR REPLACE VIEW user_accounts_with_deposits_view AS
SELECT 
    users.user_id,
    users.name,
    users.surname,
    users.email,
    users.phone_number,
    users.address,
    accounts.account_id,
    accounts.account_number,
    accounts.balance,
    accounts.currency,
    accounts.account_type,
    accounts.is_active,
    accounts.created_at AS account_created_at,
    COUNT(deposits.deposit_id) AS deposit_count,
    COALESCE(SUM(deposits.amount), 0) AS total_deposits
FROM users
INNER JOIN accounts ON users.user_id = accounts.user_id
LEFT JOIN deposits ON accounts.account_id = deposits.account_id
WHERE accounts.is_active = TRUE
GROUP BY users.user_id, users.name, users.surname, users.email, users.phone_number, users.address, 
         accounts.account_id, accounts.account_number, accounts.balance, accounts.currency, 
         accounts.account_type, accounts.is_active, accounts.created_at;

SELECT * FROM user_accounts_with_deposits_view LIMIT 5;
CREATE OR REPLACE VIEW user_accounts_view AS
SELECT 
    users.user_id,
    users.name,
    users.surname,
    users.email,
    users.phone_number,
    accounts.account_id,
    accounts.account_number,
    accounts.balance,
    accounts.currency,
    accounts.account_type,
    accounts.is_active,
    accounts.created_at AS account_created_at
FROM users
INNER JOIN accounts ON users.user_id = accounts.user_id;

SELECT * FROM user_accounts_view LIMIT 5;
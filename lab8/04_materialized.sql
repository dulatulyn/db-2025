DROP MATERIALIZED VIEW IF EXISTS transaction_stats_mv;

CREATE MATERIALIZED VIEW transaction_stats_mv AS
SELECT 
    accounts.account_id,
    accounts.account_number,
    users.user_id,
    users.name,
    users.surname,
    COUNT(transactions.transaction_id) AS total_transactions,
    SUM(transactions.amount) AS total_amount,
    AVG(transactions.amount) AS avg_transaction_amount,
    MAX(transactions.amount) AS max_transaction_amount,
    MIN(transactions.amount) AS min_transaction_amount
FROM accounts
INNER JOIN users ON accounts.user_id = users.user_id
LEFT JOIN transactions ON accounts.account_id = transactions.from_account_id
GROUP BY accounts.account_id, accounts.account_number, users.user_id, users.name, users.surname
WITH NO DATA;

REFRESH MATERIALIZED VIEW transaction_stats_mv;

SELECT COUNT(*) FROM transaction_stats_mv;

SELECT * FROM transaction_stats_mv LIMIT 5;
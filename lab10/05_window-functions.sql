SELECT 
    name,
    email,
    balance,
    ROW_NUMBER() OVER (ORDER BY balance DESC) as balance_rank,
    RANK() OVER (ORDER BY balance DESC) as balance_rank_with_ties,
    DENSE_RANK() OVER (ORDER BY balance DESC) as dense_balance_rank
FROM users;

SELECT 
    u.name,
    a.account_type,
    a.balance,
    SUM(a.balance) OVER (PARTITION BY u.user_id) as total_user_balance,
    AVG(a.balance) OVER (PARTITION BY a.account_type) as avg_type_balance,
    LAG(a.balance) OVER (ORDER BY a.created_at) as previous_account_balance,
    LEAD(a.balance) OVER (ORDER BY a.created_at) as next_account_balance
FROM users u
JOIN accounts a ON u.user_id = a.user_id;

SELECT 
    t.transaction_id,
    t.account_id,
    t.amount,
    t.transaction_type,
    SUM(t.amount) OVER (
        PARTITION BY t.account_id 
        ORDER BY t.created_at 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_balance,
    COUNT(*) OVER (
        PARTITION BY t.account_id 
        ORDER BY t.created_at 
        RANGE BETWEEN INTERVAL '1 day' PRECEDING AND CURRENT ROW
    ) as transactions_last_day
FROM transactions t
ORDER BY t.account_id, t.created_at;

SELECT 
    account_type,
    COUNT(*) as account_count,
    SUM(balance) as total_balance,
    AVG(balance) as avg_balance,
    MIN(balance) as min_balance,
    MAX(balance) as max_balance,
    PERCENT_RANK() OVER (ORDER BY SUM(balance)) as percentile_rank
FROM accounts
GROUP BY account_type;

SELECT 
    name,
    balance,
    NTILE(3) OVER (ORDER BY balance) as balance_quartile,
    FIRST_VALUE(name) OVER (ORDER BY balance DESC) as richest_user,
    LAST_VALUE(name) OVER (ORDER BY balance ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as poorest_user
FROM users;
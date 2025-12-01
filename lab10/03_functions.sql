CREATE OR REPLACE FUNCTION get_user_total_balance(user_id_param BIGINT)
RETURNS DECIMAL(15, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    total_balance DECIMAL(15, 2);
BEGIN
    SELECT COALESCE(SUM(balance), 0) INTO total_balance
    FROM accounts
    WHERE user_id = user_id_param;
    
    RETURN total_balance;
END;
$$;

CREATE OR REPLACE FUNCTION calculate_interest(
    principal DECIMAL(15, 2),
    rate DECIMAL(5, 4),
    years INTEGER
)
RETURNS DECIMAL(15, 2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN principal * POWER((1 + rate), years);
END;
$$;

CREATE OR REPLACE FUNCTION get_account_summary(
    user_id_param BIGINT,
    account_type_param VARCHAR(50) DEFAULT NULL,
    min_balance DECIMAL(15, 2) DEFAULT 0.00
)
RETURNS TABLE(
    account_id BIGINT,
    account_type VARCHAR(50),
    balance DECIMAL(15, 2),
    status VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT a.account_id, a.account_type, a.balance, a.status
    FROM accounts a
    WHERE a.user_id = user_id_param
    AND (account_type_param IS NULL OR a.account_type = account_type_param)
    AND a.balance >= min_balance
    ORDER BY a.balance DESC;
END;
$$;

SELECT get_user_total_balance(1) AS total_balance;

SELECT calculate_interest(1000.00, 0.05, 3) AS compound_interest;

SELECT * FROM get_account_summary(1);

SELECT * FROM get_account_summary(1, 'checking', 500.00);
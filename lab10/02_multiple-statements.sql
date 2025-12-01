CREATE OR REPLACE PROCEDURE process_account_transactions(
    account_id_param BIGINT,
    deposit_amount DECIMAL(15, 2),
    withdrawal_amount DECIMAL(15, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance DECIMAL(15, 2);
    account_user_id BIGINT;
BEGIN
    SELECT balance, user_id INTO current_balance, account_user_id
    FROM accounts
    WHERE account_id = account_id_param;
    
    IF current_balance IS NULL THEN
        RAISE EXCEPTION 'Account not found';
    END IF;
    
    INSERT INTO transactions (account_id, amount, transaction_type, description)
    VALUES (account_id_param, deposit_amount, 'deposit', 'Deposit transaction');
    
    UPDATE accounts
    SET balance = balance + deposit_amount
    WHERE account_id = account_id_param;
    
    SELECT balance INTO current_balance
    FROM accounts
    WHERE account_id = account_id_param;
    
    IF current_balance >= withdrawal_amount THEN
        INSERT INTO transactions (account_id, amount, transaction_type, description)
        VALUES (account_id_param, -withdrawal_amount, 'withdrawal', 'Withdrawal transaction');
        
        UPDATE accounts
        SET balance = balance - withdrawal_amount
        WHERE account_id = account_id_param;
    ELSE
        RAISE NOTICE 'Insufficient funds for withdrawal';
    END IF;
    
    UPDATE users
    SET balance = (
        SELECT COALESCE(SUM(balance), 0)
        FROM accounts
        WHERE user_id = account_user_id
    )
    WHERE user_id = account_user_id;
    
END;
$$;

CALL process_account_transactions(1, 500.00, 200.00);

SELECT * FROM accounts WHERE account_id = 1;
SELECT * FROM transactions WHERE account_id = 1 ORDER BY created_at DESC LIMIT 2;
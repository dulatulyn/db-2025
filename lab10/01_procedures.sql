CREATE OR REPLACE PROCEDURE update_balance_in(
    user_id_param BIGINT,
    amount_param DECIMAL(15, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users
    SET balance = balance + amount_param
    WHERE user_id = user_id_param;
END;
$$;

CREATE OR REPLACE PROCEDURE get_user_balance_out(
    user_id_param BIGINT,
    OUT balance_result DECIMAL(15, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT balance INTO balance_result
    FROM users
    WHERE user_id = user_id_param;
END;
$$;

CREATE OR REPLACE PROCEDURE transfer_balance_inout(
    from_user_id BIGINT,
    to_user_id BIGINT,
    INOUT transfer_amount DECIMAL(15, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    from_balance DECIMAL(15, 2);
BEGIN
    SELECT balance INTO from_balance
    FROM users
    WHERE user_id = from_user_id;
    
    IF from_balance < transfer_amount THEN
        transfer_amount = from_balance;
    END IF;
    
    UPDATE users SET balance = balance - transfer_amount WHERE user_id = from_user_id;
    UPDATE users SET balance = balance + transfer_amount WHERE user_id = to_user_id;
END;
$$;

CALL update_balance_in(1, 100.00);

DO $$
DECLARE
    balance_out DECIMAL(15, 2);
BEGIN
    CALL get_user_balance_out(1, balance_out);
    RAISE NOTICE 'User balance: %', balance_out;
END;
$$;

DO $$
DECLARE
    transfer_amt DECIMAL(15, 2) := 200.00;
BEGIN
    CALL transfer_balance_inout(1, 2, transfer_amt);
    RAISE NOTICE 'Actual transfer amount: %', transfer_amt;
END;
$$;
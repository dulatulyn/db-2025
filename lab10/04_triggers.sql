CREATE TABLE IF NOT EXISTS audit_log (
    log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_user_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, operation, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), user);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), user);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), user);
        RETURN OLD;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION update_user_balance_on_account_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        UPDATE users
        SET balance = (
            SELECT COALESCE(SUM(balance), 0)
            FROM accounts
            WHERE user_id = NEW.user_id
        )
        WHERE user_id = NEW.user_id;
        RETURN NEW;
    END IF;
END;
$$;

CREATE TRIGGER users_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW
    EXECUTE FUNCTION log_user_changes();

CREATE TRIGGER accounts_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION log_user_changes();

CREATE TRIGGER update_user_balance_trigger
    AFTER UPDATE OF balance ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_user_balance_on_account_change();

INSERT INTO users (name, email, balance) VALUES ('Test User', 'test@email.com', 0);

UPDATE accounts SET balance = 1500.00 WHERE account_id = 1;

DELETE FROM users WHERE name = 'Test User';

SELECT * FROM audit_log ORDER BY changed_at DESC;
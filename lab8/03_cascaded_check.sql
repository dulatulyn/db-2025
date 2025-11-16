CREATE OR REPLACE VIEW active_loans_view AS
SELECT 
    loan_id,
    amount,
    interest_rate,
    start_date,
    end_date,
    status,
    account_id
FROM loans
WHERE status = 'active' AND amount > 1000
WITH CASCADED CHECK OPTION;

SELECT * FROM active_loans_view LIMIT 5;
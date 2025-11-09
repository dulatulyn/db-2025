CREATE INDEX idx_loans_start_date ON loans USING BRIN (start_date);

SELECT loan_id, account_id, amount, start_date, status
FROM loans
WHERE start_date >= '2024-01-01';
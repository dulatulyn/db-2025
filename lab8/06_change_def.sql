DROP VIEW IF EXISTS user_loan_summary;

CREATE OR REPLACE VIEW user_loan_summary AS
SELECT 
    users.user_id,
    users.name,
    users.surname,
    COUNT(loans.loan_id) AS loan_count,
    SUM(loans.amount) AS total_loans
FROM users
LEFT JOIN loans ON users.user_id = loans.account_id
GROUP BY users.user_id, users.name, users.surname;

ALTER VIEW user_loan_summary 
ALTER COLUMN loan_count SET DEFAULT 0;

DROP VIEW IF EXISTS user_loan_summary;

CREATE OR REPLACE VIEW user_loan_summary AS
SELECT 
    users.user_id,
    users.name,
    users.surname,
    users.email,
    COUNT(loans.loan_id) AS loan_count,
    SUM(loans.amount) AS total_loans,
    AVG(loans.interest_rate) AS avg_interest_rate
FROM users
LEFT JOIN loans ON users.user_id = loans.account_id
GROUP BY users.user_id, users.name, users.surname, users.email;

ALTER VIEW user_loan_summary SET SCHEMA public;
ALTER VIEW user_loan_summary OWNER TO postgres;

SELECT * FROM user_loan_summary LIMIT 5;
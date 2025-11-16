CREATE DATABASE banking_db;

\c banking_db;

CREATE TABLE IF NOT EXISTS users (
  user_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  surname      VARCHAR(100) NOT NULL,
  email        VARCHAR(255) NOT NULL UNIQUE,
  password     VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  pincode      CHAR(4) NOT NULL,
  address      TEXT,
  status       VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts (
  account_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id        BIGINT NOT NULL,
  account_number CHAR(20) NOT NULL UNIQUE,
  balance        NUMERIC(15,2) NOT NULL DEFAULT 0,
  currency       CHAR(3) NOT NULL DEFAULT 'KZT',
  account_type   VARCHAR(30) NOT NULL,
  is_active      BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cards (
  card_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id     BIGINT NOT NULL,
  card_number    CHAR(16) NOT NULL UNIQUE,
  bic            VARCHAR(11),
  cvc            CHAR(3) NOT NULL,
  expiration_date DATE NOT NULL,
  card_type      VARCHAR(20) NOT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS transactions (
  transaction_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  from_account_id  BIGINT NOT NULL,
  to_account_id    BIGINT NOT NULL,
  amount           NUMERIC(15,2) NOT NULL,
  bank_fee         NUMERIC(15,2) NOT NULL DEFAULT 0,
  transaction_type VARCHAR(30) NOT NULL,
  description      TEXT,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (from_account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
  FOREIGN KEY (to_account_id)   REFERENCES accounts(account_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS loans (
  loan_id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id    BIGINT NOT NULL,
  amount        NUMERIC(15,2) NOT NULL,
  interest_rate NUMERIC(5,2) NOT NULL,
  start_date    DATE NOT NULL DEFAULT CURRENT_DATE,
  end_date      DATE,
  status        VARCHAR(20) NOT NULL DEFAULT 'active',
  FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS deposits (
  deposit_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id    BIGINT NOT NULL,
  amount        NUMERIC(15,2) NOT NULL,
  interest_rate NUMERIC(5,2) NOT NULL,
  start_date    DATE NOT NULL DEFAULT CURRENT_DATE,
  end_date      DATE,
  status        VARCHAR(20) NOT NULL DEFAULT 'active',
  FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS audit_logs (
  log_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id    BIGINT NOT NULL,
  action     VARCHAR(255) NOT NULL,
  details    TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO users (name, surname, email, password, phone_number, pincode, address)
VALUES
('Nursultan','Akhmet','nursultan.akhmet@example.com','hash1','+7 7012345678','1234','Almaty, Dostyk 1'),
('Aigerim','Tuleu','aigerim.tuleu@example.com','hash2','+7 7022345678','2345','Astana, Saraishyk 2'),
('Yerassyl','Bek','yerassyl.bek@example.com','hash3','+7 7032345678','3456','Almaty, Abay 10'),
('Danel','Karim','danel.karim@example.com','hash4','+7 7042345678','4567','Shymkent, Tauke 5'),
('Aisulu','Naz','aisulu.naz@example.com','hash5','+7 7052345678','5678','Almaty, Satpayev 20'),
('Dias','Sapar','dias.sapar@example.com','hash6','+7 7062345678','6789','Astana, Turan 9'),
('Adilet','Nur','adilet.nur@example.com','hash7','+7 7072345678','7890','Karaganda, Mira 7'),
('Madina','Alim','madina.alim@example.com','hash8','+7 7082345678','8901','Almaty, Tole bi 15');

INSERT INTO accounts (user_id, account_number, balance, currency, account_type, is_active)
VALUES
(1, 'KZ12345678901234567890', 15000.00, 'KZT', 'checking', TRUE),
(1, 'KZ12345678901234567891', 25000.00, 'KZT', 'savings', TRUE),
(2, 'KZ12345678901234567892', 35000.00, 'KZT', 'checking', TRUE),
(3, 'KZ12345678901234567893', 45000.00, 'KZT', 'savings', TRUE),
(4, 'KZ12345678901234567894', 55000.00, 'KZT', 'checking', TRUE),
(5, 'KZ12345678901234567895', 65000.00, 'KZT', 'savings', TRUE),
(6, 'KZ12345678901234567896', 75000.00, 'KZT', 'checking', TRUE),
(7, 'KZ12345678901234567897', 85000.00, 'KZT', 'savings', TRUE),
(8, 'KZ12345678901234567898', 95000.00, 'KZT', 'checking', TRUE);

INSERT INTO cards (account_id, card_number, bic, cvc, expiration_date, card_type)
VALUES
(1, '1234567890123456', 'CASPKZKA', '123', '2025-12-31', 'credit'),
(2, '1234567890123457', 'CASPKZKA', '234', '2025-12-31', 'debit'),
(3, '1234567890123458', 'CASPKZKA', '345', '2025-12-31', 'credit'),
(4, '1234567890123459', 'CASPKZKA', '456', '2025-12-31', 'debit'),
(5, '1234567890123460', 'CASPKZKA', '567', '2025-12-31', 'credit'),
(6, '1234567890123461', 'CASPKZKA', '678', '2025-12-31', 'debit'),
(7, '1234567890123462', 'CASPKZKA', '789', '2025-12-31', 'credit'),
(8, '1234567890123463', 'CASPKZKA', '890', '2025-12-31', 'debit');

INSERT INTO transactions (from_account_id, to_account_id, amount, bank_fee, transaction_type, description)
VALUES
(1, 2, 1000.00, 50.00, 'transfer', 'Monthly rent payment'),
(2, 3, 2000.00, 100.00, 'transfer', 'Business transaction'),
(3, 4, 1500.00, 75.00, 'transfer', 'Service payment'),
(4, 5, 3000.00, 150.00, 'transfer', 'Invoice payment'),
(5, 6, 2500.00, 125.00, 'transfer', 'Consultation fee'),
(6, 7, 1800.00, 90.00, 'transfer', 'Project payment'),
(7, 8, 2200.00, 110.00, 'transfer', 'Monthly service');

INSERT INTO loans (account_id, amount, interest_rate, start_date, end_date, status)
VALUES
(1, 10000.00, 12.5, '2024-01-01', '2025-01-01', 'active'),
(2, 20000.00, 11.0, '2024-02-01', '2026-02-01', 'active'),
(3, 15000.00, 13.0, '2024-03-01', '2025-03-01', 'active'),
(4, 30000.00, 10.5, '2024-04-01', '2027-04-01', 'active'),
(5, 25000.00, 12.0, '2024-05-01', '2026-05-01', 'active');

INSERT INTO deposits (account_id, amount, interest_rate, start_date, end_date, status)
VALUES
(6, 50000.00, 8.5, '2024-01-01', '2025-01-01', 'active'),
(7, 60000.00, 9.0, '2024-02-01', '2025-02-01', 'active'),
(8, 70000.00, 8.0, '2024-03-01', '2025-03-01', 'active');

INSERT INTO audit_logs (user_id, action, details)
VALUES
(1, 'LOGIN', 'User logged in successfully'),
(2, 'TRANSFER', 'Transfer of 1000 KZT completed'),
(3, 'WITHDRAWAL', 'Withdrawal of 500 KZT from ATM'),
(4, 'DEPOSIT', 'Cash deposit of 2000 KZT'),
(5, 'LOGIN', 'User logged in successfully'),
(6, 'TRANSFER', 'Transfer of 1500 KZT completed'),
(7, 'PAYMENT', 'Utility bill payment of 300 KZT'),
(8, 'LOGIN', 'User logged in successfully');
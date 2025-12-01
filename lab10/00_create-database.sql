CREATE DATABASE lab10_db;

\c lab10_db;

CREATE TABLE IF NOT EXISTS users (
  user_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(255) NOT NULL UNIQUE,
  balance      DECIMAL(15, 2) DEFAULT 0.00 CHECK (balance >= 0),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts (
  account_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id      BIGINT NOT NULL,
  account_type VARCHAR(50) NOT NULL DEFAULT 'checking',
  balance      DECIMAL(15, 2) DEFAULT 0.00 CHECK (balance >= 0),
  status       VARCHAR(20) DEFAULT 'active',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS transactions (
  transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id     BIGINT NOT NULL,
  amount         DECIMAL(15, 2) NOT NULL,
  transaction_type VARCHAR(20) NOT NULL,
  description    TEXT,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO users (name, email, balance) VALUES
('John Smith', 'john@email.com', 1500.00),
('Alice Johnson', 'alice@email.com', 2300.50),
('Bob Brown', 'bob@email.com', 800.75);

INSERT INTO accounts (user_id, account_type, balance) VALUES
(1, 'checking', 1200.00),
(1, 'savings', 300.00),
(2, 'checking', 2300.50),
(3, 'checking', 800.75);
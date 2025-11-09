CREATE INDEX idx_users_email ON users USING BTREE (email);

SELECT user_id, name, surname, email 
FROM users 
WHERE email = 'nursultan.akhmet@example.com';
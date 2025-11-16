CREATE OR REPLACE VIEW temporary_user_cards_view AS
SELECT 
    users.user_id,
    users.name,
    users.surname,
    users.email,
    cards.card_id,
    cards.card_number,
    cards.card_type,
    cards.expiration_date
FROM users
INNER JOIN accounts ON users.user_id = accounts.user_id
INNER JOIN cards ON accounts.account_id = cards.account_id;

SELECT * FROM temporary_user_cards_view LIMIT 3;

SELECT viewname FROM pg_views WHERE viewname = 'temporary_user_cards_view';

DROP VIEW IF EXISTS temporary_user_cards_view;

SELECT viewname FROM pg_views WHERE viewname = 'temporary_user_cards_view';
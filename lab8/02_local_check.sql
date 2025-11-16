CREATE OR REPLACE VIEW active_credit_cards_view AS
SELECT 
    card_id,
    card_number,
    cvc,
    expiration_date,
    card_type,
    account_id
FROM cards
WHERE card_type = 'credit'
WITH LOCAL CHECK OPTION;

SELECT * FROM active_credit_cards_view LIMIT 5;
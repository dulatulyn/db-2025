ALTER TABLE deposits ADD COLUMN valid_period TSRANGE;

UPDATE deposits 
SET valid_period = tsrange(start_date::timestamp, end_date::timestamp)
WHERE end_date IS NOT NULL;

UPDATE deposits 
SET valid_period = tsrange(start_date::timestamp, (start_date + INTERVAL '1 year')::timestamp)
WHERE end_date IS NULL;

CREATE INDEX idx_deposits_valid_period ON deposits USING GIST (valid_period);

SELECT deposit_id, account_id, amount, valid_period
FROM deposits
WHERE valid_period @> '2024-06-01'::timestamp;
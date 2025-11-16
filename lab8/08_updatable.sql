CREATE OR REPLACE VIEW recent_audit_logs_view AS
SELECT 
    audit_logs.log_id,
    audit_logs.user_id,
    audit_logs.action,
    audit_logs.details,
    audit_logs.created_at
FROM audit_logs
WHERE audit_logs.created_at >= CURRENT_DATE - INTERVAL '30 days';

SELECT 
    table_name,
    is_updatable,
    is_insertable_into
FROM information_schema.views 
WHERE table_name = 'recent_audit_logs_view';

INSERT INTO recent_audit_logs_view (user_id, action, details, created_at)
VALUES 
(1, 'VIEW_TEST_INSERT', 'Testing updatable view insertion', CURRENT_TIMESTAMP),
(2, 'VIEW_TEST_INSERT_2', 'Another test insertion', CURRENT_TIMESTAMP);

UPDATE recent_audit_logs_view 
SET action = 'VIEW_TEST_UPDATED', details = 'Updated via view'
WHERE action = 'VIEW_TEST_INSERT';

DELETE FROM recent_audit_logs_view 
WHERE action = 'VIEW_TEST_INSERT_2';

SELECT * FROM recent_audit_logs_view 
WHERE action LIKE 'VIEW_TEST%' 
ORDER BY created_at DESC;

SELECT * FROM audit_logs 
WHERE action LIKE 'VIEW_TEST%' 
ORDER BY created_at DESC;
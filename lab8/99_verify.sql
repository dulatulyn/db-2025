SELECT viewname, schemaname FROM pg_views WHERE viewname LIKE '%view%' ORDER BY viewname;

SELECT matviewname, schemaname FROM pg_matviews ORDER BY matviewname;

SELECT COUNT(*) FROM user_accounts_with_deposits_view;

SELECT COUNT(*) FROM active_credit_cards_view;

SELECT COUNT(*) FROM active_loans_view;

SELECT COUNT(*) FROM transaction_stats_mv;

SELECT COUNT(*) FROM user_loan_summary;

SELECT COUNT(*) FROM recent_audit_logs_view;

SELECT 
    rolname,
    rolcanlogin,
    rolcreaterole,
    rolcreatedb,
    rolsuper
FROM pg_roles 
WHERE rolname LIKE 'bank_%'
ORDER BY rolname;

SELECT 
    r1.rolname AS group_role,
    r2.rolname AS member_role
FROM pg_roles r1
JOIN pg_auth_members m ON r1.oid = m.roleid
JOIN pg_roles r2 ON m.member = r2.oid
WHERE r1.rolname LIKE 'bank_%'
ORDER BY r1.rolname, r2.rolname;

SELECT 
    table_name,
    grantee,
    privilege_type,
    is_grantable
FROM information_schema.role_table_grants 
WHERE grantee LIKE 'bank_%'
ORDER BY table_name, grantee, privilege_type;
CREATE ROLE bank_staff WITH NOLOGIN;
CREATE ROLE bank_management WITH NOLOGIN;

GRANT bank_staff TO bank_teller;
GRANT bank_staff TO bank_analyst;
GRANT bank_management TO bank_manager;
GRANT bank_management TO bank_admin;

GRANT SELECT ON users TO bank_staff;
GRANT SELECT ON accounts TO bank_staff;
GRANT SELECT ON cards TO bank_staff;
GRANT SELECT, INSERT, UPDATE ON transactions TO bank_staff;
GRANT SELECT ON deposits TO bank_staff;

GRANT SELECT, INSERT, UPDATE, DELETE ON users TO bank_management;
GRANT SELECT, INSERT, UPDATE, DELETE ON accounts TO bank_management;
GRANT SELECT, INSERT, UPDATE, DELETE ON loans TO bank_management;
GRANT SELECT, INSERT, UPDATE, DELETE ON audit_logs TO bank_management;

SELECT 
    r1.rolname AS group_role,
    r2.rolname AS member_role
FROM pg_roles r1
JOIN pg_auth_members m ON r1.oid = m.roleid
JOIN pg_roles r2 ON m.member = r2.oid
WHERE r1.rolname IN ('bank_staff', 'bank_management')
ORDER BY r1.rolname, r2.rolname;

REVOKE INSERT, UPDATE ON transactions FROM bank_staff;
REVOKE DELETE ON users FROM bank_management;

SELECT 
    table_name,
    grantee,
    privilege_type,
    is_grantable
FROM information_schema.role_table_grants 
WHERE grantee IN ('bank_staff', 'bank_management')
ORDER BY table_name, grantee, privilege_type;

GRANT SELECT (user_id, name, surname, email) ON users TO bank_staff;
GRANT UPDATE (balance) ON accounts TO bank_management;
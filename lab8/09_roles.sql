DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bank_analyst') THEN
        CREATE ROLE bank_analyst;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bank_teller') THEN
        CREATE ROLE bank_teller WITH LOGIN PASSWORD 'teller123';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bank_manager') THEN
        CREATE ROLE bank_manager WITH LOGIN CREATEROLE PASSWORD 'manager123';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bank_admin') THEN
        CREATE ROLE bank_admin WITH LOGIN CREATEROLE CREATEDB PASSWORD 'admin123';
    END IF;
END $$;

SELECT 
    rolname,
    rolcanlogin,
    rolcreaterole,
    rolcreatedb,
    rolsuper
FROM pg_roles 
WHERE rolname IN ('bank_analyst', 'bank_teller', 'bank_manager', 'bank_admin')
ORDER BY rolname;

GRANT CONNECT ON DATABASE banking_db TO bank_teller, bank_manager, bank_admin;
GRANT USAGE ON SCHEMA public TO bank_teller, bank_manager, bank_admin;

ALTER ROLE bank_teller VALID UNTIL '2025-12-31';
ALTER ROLE bank_manager SET search_path TO public;

\du bank_teller
\du bank_manager
\du bank_admin
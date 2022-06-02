-- Dentro do Banco XXX
CREATE USER "dblink" WITH PASSWORD 'dblink';
GRANT CONNECT ON DATABASE "Banco XXX" TO "dblink";
GRANT USAGE ON SCHEMA cadastro TO "dblink";
GRANT SELECT ON ALL TABLES IN SCHEMA cadastro TO "dblink";
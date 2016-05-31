--liquibase formatted sql

--changeset hubofallthings:noPublicAccess context:data

SET search_path TO hat,public;

-- GRANT SELECT, INSERT, UPDATE, DELETE
-- ON ALL TABLES IN SCHEMA public 
-- TO XXX;

REVOKE ALL ON DATABASE hat_template FROM public;
REVOKE ALL ON SCHEMA hat FROM public;
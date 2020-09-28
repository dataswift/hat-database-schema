--liquibase formatted sql

-- See DSE-573
INSERT INTO hat.user_role_available VALUES ('verified');

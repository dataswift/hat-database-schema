--liquibase formatted sql

--changeset hubofallthings:dbtokens context:structuresonly

ALTER TABLE hat.user_access_token ADD COLUMN scope VARCHAR NOT NULL DEFAULT('');

ALTER TABLE hat.user_access_token ADD COLUMN resource VARCHAR NOT NULL DEFAULT('');

--rollback ALTER TABLE hat.user_access_token DROP COLUMN scope;
--rollback ALTER TABLE hat.user_access_token DROP COLUMN resource;
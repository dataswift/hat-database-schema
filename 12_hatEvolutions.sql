--liquibase formatted sql

--changeset hubofallthings:dbtokens context:structuresonly

ALTER TABLE hat.user_access_token ADD COLUMN scope VARCHAR NOT NULL DEFAULT ('');

ALTER TABLE hat.user_access_token ADD COLUMN resource VARCHAR NOT NULL DEFAULT ('');

--rollback ALTER TABLE hat.user_access_token DROP COLUMN scope;
--rollback ALTER TABLE hat.user_access_token DROP COLUMN resource;

--changeset hubofallthings:statistics context:structuresonly

CREATE SEQUENCE hat.stats_data_debit_operation_seq;

CREATE TABLE hat.stats_data_debit_operation (
  record_id    INTEGER   NOT NULL DEFAULT nextval('hat.stats_data_debit_operation_seq') PRIMARY KEY,
  date_created TIMESTAMP NOT NULL DEFAULT (NOW()),
  data_debit   UUID      NOT NULL REFERENCES hat.data_debit (data_debit_key),
  hat_user     UUID      NOT NULL REFERENCES hat.user_user (user_id),
  operation    VARCHAR   NOT NULL
);

CREATE SEQUENCE hat.stats_data_debit_data_table_access_seq;

CREATE TABLE hat.stats_data_debit_data_table_access (
  record_id            INTEGER   NOT NULL DEFAULT nextval('hat.stats_data_debit_data_table_access_seq') PRIMARY KEY,
  date_created         TIMESTAMP NOT NULL DEFAULT (NOW()),
  table_id             INTEGER   NOT NULL REFERENCES hat.data_table (id),
  data_debit_operation INTEGER   NOT NULL REFERENCES hat.stats_data_debit_operation (record_id),
  value_count          INTEGER   NOT NULL DEFAULT (0)
);

CREATE SEQUENCE hat.stats_data_debit_data_field_access_seq;

CREATE TABLE hat.stats_data_debit_data_field_access (
  record_id            INTEGER   NOT NULL DEFAULT nextval('hat.stats_data_debit_data_field_access_seq') PRIMARY KEY,
  date_created         TIMESTAMP NOT NULL DEFAULT (NOW()),
  field_id             INTEGER   NOT NULL REFERENCES hat.data_field (id),
  data_debit_operation INTEGER   NOT NULL REFERENCES hat.stats_data_debit_operation (record_id),
  value_count          INTEGER   NOT NULL DEFAULT (0)
);

CREATE SEQUENCE hat.stats_data_debit_record_count_seq;

CREATE TABLE hat.stats_data_debit_record_count (
  record_id            INTEGER   NOT NULL DEFAULT nextval('hat.stats_data_debit_record_count_seq') PRIMARY KEY,
  date_created         TIMESTAMP NOT NULL DEFAULT (NOW()),
  data_debit_operation INTEGER   NOT NULL REFERENCES hat.stats_data_debit_operation (record_id),
  record_count         INTEGER   NOT NULL DEFAULT (0)
);

CREATE SEQUENCE hat.stats_data_debit_cless_bundle_records_seq;

CREATE TABLE hat.stats_data_debit_cless_bundle_records (
  record_id             INTEGER   NOT NULL DEFAULT nextval('hat.stats_data_debit_cless_bundle_records_seq') PRIMARY KEY,
  date_created          TIMESTAMP NOT NULL DEFAULT (NOW()),
  bundle_contextless_id INTEGER   NOT NULL REFERENCES hat.bundle_contextless_table (id),
  data_debit_operation  INTEGER   NOT NULL REFERENCES hat.stats_data_debit_operation (record_id),
  record_count          INTEGER   NOT NULL DEFAULT (0)
);

--rollback DROP TABLE hat.stats_data_debit_cless_bundle_records;
--rollback DROP SEQUENCE hat.stats_data_debit_cless_bundle_records_seq;

--rollback DROP TABLE hat.stats_data_debit_record_count;
--rollback DROP SEQUENCE hat.stats_data_debit_record_count_seq;

--rollback DROP TABLE hat.stats_data_debit_data_field_access;
--rollback DROP SEQUENCE hat.stats_data_debit_data_field_access_seq;
--rollback DROP TABLE hat.stats_data_debit_data_table_access;
--rollback DROP SEQUENCE hat.stats_data_debit_data_table_access_seq;
--rollback DROP TABLE hat.stats_data_debit_operation;
--rollback DROP SEQUENCE hat.stats_data_debit_operation_seq;
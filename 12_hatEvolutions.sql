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

--changeset hubofallthings:recursiveStructureViews context:structuresonly

CREATE VIEW hat.data_table_tree AS WITH RECURSIVE recursive_table(id, date_created, last_updated, name, source_name, table1) AS (
  SELECT
    b.id,
    b.date_created,
    b.last_updated,
    b.name,
    b.source_name,
    b2b.table1,
    array[b.id] AS path,
    b.id as root_table
  FROM hat.data_table b
    LEFT JOIN hat.data_tabletotablecrossref b2b
      ON b.id = b2b.table2
  UNION ALL
  SELECT
    b.id,
    b.date_created,
    b.last_updated,
    b.name,
    b.source_name,
    b2b.table1,
    (r_b.path || b.id),
    path[1] as root_table
  FROM recursive_table r_b, hat.data_table b
    LEFT JOIN hat.data_tabletotablecrossref b2b
      ON b.id = b2b.table2
  WHERE b2b.table1 = r_b.id
)
SELECT *
FROM recursive_table;

CREATE VIEW hat.bundle_context_tree AS WITH RECURSIVE recursive_bundle_context(id, date_created, last_updated, name, bundle_parent) AS (
  SELECT
    b.id,
    b.date_created,
    b.last_updated,
    b.name,
    b2b.bundle_parent,
    ARRAY [b.id] AS path,
    b.id as root_bundle
  FROM hat.bundle_context b
    LEFT JOIN hat.bundle_context_to_bundle_crossref b2b
      ON b.id = b2b.bundle_child
  UNION ALL
  SELECT
    b.id,
    b.date_created,
    b.last_updated,
    b.name,
    b2b.bundle_parent,
    (r_b.path || b.id),
    path[1] as root_table
  FROM recursive_bundle_context r_b, hat.bundle_context b
    LEFT JOIN hat.bundle_context_to_bundle_crossref b2b
      ON b.id = b2b.bundle_child
  WHERE b2b.bundle_parent = r_b.id
)
SELECT *
FROM recursive_bundle_context;

--rollback DROP VIEW data_table_tree;
--rollback DROP VIEW bundle_context_tree;
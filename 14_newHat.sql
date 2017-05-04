--liquibase formatted sql

--changeset hubofallthings:jsonData context:structuresonly

CREATE TABLE hat.data_json (
  record_id UUID      NOT NULL PRIMARY KEY,
  source    VARCHAR   NOT NULL,
  owner     UUID      NOT NULL REFERENCES hat.user_user (user_id),
  date      TIMESTAMP NOT NULL DEFAULT (NOW()),
  data      JSONB     NOT NULL,
  hash      BYTEA NOT NULL UNIQUE
);

--rollback DROP TABLE hat.data_json;

--changeset hubofallthings:jsonDataGroups context:structuresonly

CREATE TABLE hat.data_json_groups (
  group_id UUID      NOT NULL PRIMARY KEY,
  owner    UUID      NOT NULL REFERENCES hat.user_user (user_id),
  date     TIMESTAMP NOT NULL DEFAULT (NOW())
);

CREATE TABLE hat.data_json_group_records (
  group_id  UUID NOT NULL REFERENCES hat.data_json_groups (group_id),
  record_id UUID NOT NULL REFERENCES hat.data_json (record_id),
  PRIMARY KEY (group_id, record_id)
);

--rollback DROP TABLE hat.data_json_group_records;
--rollback DROP TABLE hat.data_json_groups;

--changeset hubofallthings:combinators-bundles context:structuresonly

CREATE TABLE hat.data_combinators (
  combinator_id VARCHAR NOT NULL PRIMARY KEY,
  combinator    JSONB   NOT NULL
);

CREATE TABLE hat.data_bundles (
  bundle_id VARCHAR NOT NULL PRIMARY KEY,
  bundle    JSONB   NOT NULL
);

--rollback DROP TABLE hat.data_combinators;
--rollback DROP TABLE hat.data_bundles;

--changeset hubofallthings:hatServiceNamespaces
ALTER TABLE hat.applications ADD COLUMN namespace VARCHAR NOT NULL DEFAULT('');
UPDATE hat.applications SET namespace = lower(title);
UPDATE hat.applications SET namespace = 'rumpel' WHERE title = 'RumpelLite';

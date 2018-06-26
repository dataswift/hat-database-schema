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

--changeset hubofallthings:newDataDebits

CREATE TABLE hat.data_debit_contract (
  data_debit_key VARCHAR   NOT NULL PRIMARY KEY,
  date_created   TIMESTAMP NOT NULL,
  client_id      UUID      NOT NULL REFERENCES hat.user_user (user_id)
);

CREATE TABLE hat.data_debit_bundle (
  data_debit_key VARCHAR   NOT NULL REFERENCES hat.data_debit_contract (data_debit_key),
  bundle_id      VARCHAR   NOT NULL REFERENCES hat.data_bundles (bundle_id),
  date_created   TIMESTAMP NOT NULL,
  start_date     TIMESTAMP NOT NULL,
  end_date       TIMESTAMP NOT NULL,
  rolling        BOOLEAN   NOT NULL,
  enabled        BOOLEAN   NOT NULL,
  PRIMARY KEY (data_debit_key, bundle_id)
);

--changeset hubofallthings:userRoles

CREATE TABLE hat.user_role_available (
  name VARCHAR PRIMARY KEY
);

CREATE TABLE hat.user_role (
  user_id UUID REFERENCES hat.user_user (user_id)            NOT NULL,
  role    VARCHAR REFERENCES hat.user_role_available (name)  NOT NULL,
  extra   VARCHAR
);

INSERT INTO hat.user_role_available VALUES ('owner');
INSERT INTO hat.user_role_available VALUES ('platform');
INSERT INTO hat.user_role_available VALUES ('validate');

INSERT INTO hat.user_role_available VALUES ('datadebit');
INSERT INTO hat.user_role_available VALUES ('datacredit');
INSERT INTO hat.user_role_available VALUES ('namespacewrite');
INSERT INTO hat.user_role_available VALUES ('namespaceread');

INSERT INTO hat.user_role SELECT user_id, lower(role), NULL
                          FROM hat.user_user;

ALTER TABLE hat.user_user
  DROP COLUMN role;

--rollback ALTER TABLE hat.user_user ADD COLUMN role VARCHAR NOT NULL DEFAULT('');
--rollback UPDATE hat.user_user SET hat.user_user.role = hat.user_role.role FROM hat.user_role WHERE hat.user_user.user_id = hat.user_role.user_id
--rollback DROP TABLE hat.user_role;
--rollback DROP TABLE hat.user_role_available;

--changeset hubofallthings:presetApplications context:data,testdata runOnChange:true

DELETE FROM hat.applications WHERE title = 'Xtiva';
INSERT INTO hat.applications (title, description, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('Xtiva', 'Private hyperdata browser for your HAT data', '/assets/images/Rumpel-logo.svg',
        'https://xtiva-rumpel.hubat.net', '/users/authenticate', TRUE, 'app', TRUE, TRUE);

DELETE FROM hat.applications WHERE title = 'SurreyCODE';
INSERT INTO hat.applications (title, description, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('SurreyCODE', 'Private hyperdata browser for your HAT data', '/assets/images/Rumpel-logo.svg',
        'https://rumpel.surreycode.net', '/users/authenticate', TRUE, 'app', TRUE, TRUE);

DELETE FROM hat.applications WHERE title = 'RumpelStaging';
INSERT INTO hat.applications (title, description, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('RumpelStaging', 'Private hyperdata browser for your HAT data', '/assets/images/Rumpel-logo.svg',
        'http://rumpel.hubat.net', '/users/authenticate', TRUE,
        'testapp', TRUE, TRUE);

DELETE FROM hat.applications WHERE title = 'Tamo';
INSERT INTO hat.applications (title, description, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('Tamo', 'Private hyperdata browser for your HAT data', '/assets/images/Rumpel-logo.svg',
        'http://tamo-rumpel.hubat.net', '/users/authenticate', TRUE,
        'app', TRUE, TRUE);

--rollback DELETE FROM hat.applications WHERE title = 'Xtiva';
--rollback DELETE FROM hat.applications WHERE title = 'SurreyCODE';
--rollback DELETE FROM hat.applications WHERE title = 'RumpelStaging';

--changeset hubofallthings:presetApplicationUpdates context:data,testdata

UPDATE hat.applications SET title = 'RumpelStage'
WHERE title = 'Rumpel' AND url='http://rumpel-stage.hubofallthings.com.s3-website-eu-west-1.amazonaws.com';

UPDATE hat.applications SET url = 'https://rumpel.hubat.net'
WHERE title = 'RumpelStaging';

--rollback UPDATE hat.applications SET title = 'Rumpel' WHERE title = 'RumpelStage';

--changeset hubofallthings:applicationKeys context:structuresonly

ALTER TABLE hat.applications DROP CONSTRAINT applications_pkey;

ALTER TABLE hat.applications ADD PRIMARY KEY (title);

ALTER TABLE hat.applications DROP COLUMN application_id;

DROP SEQUENCE hat.application_seq;

--rollback CREATE SEQUENCE hat.application_seq;
--rollback ALTER TABLE hat.applications ADD COLUMN application_id INTEGER NOT NULL DEFAULT (nextval('hat.application_seq'));
--rollback ALTER TABLE hat.applications DROP CONSTRAINT hat.applications_pkey;
--rollback ALTER TABLE hat.applications ADD PRIMARY KEY (aplication_id);

--changeset hubofallthings:dataDebitConditions context:structuresonly

ALTER TABLE hat.data_debit_bundle ADD COLUMN conditions VARCHAR REFERENCES hat.data_bundles(bundle_id);
--rollback ALTER TABLE hat.data_debit_bundle DROP COLUMN conditions;

--changeset hubofallthings:removedObsoleteTables context:structuresonly

ALTER TABLE hat.bundle_context_property_selection DROP CONSTRAINT IF EXISTS property_selection_entity_selection__fk;
ALTER TABLE hat.bundle_context_to_bundle_crossref DROP CONSTRAINT IF EXISTS  bundle_context_bundle_bundletobundlecrossref_fk;
ALTER TABLE hat.bundle_context_to_bundle_crossref DROP CONSTRAINT IF EXISTS bundle_context_bundle_bundletobundlecrossref_fk1;
ALTER TABLE hat.events_eventlocationcrossref DROP CONSTRAINT IF EXISTS locations_location_events_eventlocationcrossref_fk;
ALTER TABLE hat.events_eventlocationcrossref DROP CONSTRAINT IF EXISTS events_eventlocationcrossref_fk;
ALTER TABLE hat.events_eventlocationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_events_eventlocationcrossref_fk;
ALTER TABLE hat.events_eventorganisationcrossref DROP CONSTRAINT IF EXISTS organisations_organisation_events_eventorganisationcrossref_fk;
ALTER TABLE hat.events_eventorganisationcrossref DROP CONSTRAINT IF EXISTS events_eventorganisationcrossref_fk;
ALTER TABLE hat.events_eventorganisationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_events_eventorganisationcrossref_fk;
ALTER TABLE hat.events_eventpersoncrossref DROP CONSTRAINT IF EXISTS people_person_people_eventpersoncrossref_fk;
ALTER TABLE hat.events_eventpersoncrossref DROP CONSTRAINT IF EXISTS events_eventpersoncrossref_thing_id_fkey;
ALTER TABLE hat.events_eventpersoncrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_events_eventpersoncrossref_fk;
ALTER TABLE hat.events_eventthingcrossref DROP CONSTRAINT IF EXISTS events_thingeventcrossref_fk;
ALTER TABLE hat.events_eventthingcrossref DROP CONSTRAINT IF EXISTS events_eventthingcrossref_fk;
ALTER TABLE hat.events_eventthingcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_events_eventthingcrossref_fk;
ALTER TABLE hat.events_eventtoeventcrossref DROP CONSTRAINT IF EXISTS event_one_id_refs_id_fk;
ALTER TABLE hat.events_eventtoeventcrossref DROP CONSTRAINT IF EXISTS event_two_id_refs_id_fk;
ALTER TABLE hat.events_eventtoeventcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_events_eventtoeventcrossref_fk;
ALTER TABLE hat.events_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS events_systempropertydynamiccrossref_fk;
ALTER TABLE hat.events_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS system_property_events_systempropertydynamiccrossref_fk;
ALTER TABLE hat.events_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS data_field_events_systempropertydynamiccrossref_fk;
ALTER TABLE hat.events_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS property_record_events_systempropertydynamiccrossref_fk;
ALTER TABLE hat.events_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS events_systempropertycrossref_fk;
ALTER TABLE hat.events_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS system_property_events_systempropertystaticcrossref_fk;
ALTER TABLE hat.events_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_record_events_systempropertystaticcrossref_fk;
ALTER TABLE hat.events_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_field_events_systempropertystaticcrossref_fk;
ALTER TABLE hat.events_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS property_record_events_systempropertystaticcrossref_fk;
ALTER TABLE hat.events_systemtypecrossref DROP CONSTRAINT IF EXISTS events_systemtypecrossref_fk;
ALTER TABLE hat.events_systemtypecrossref DROP CONSTRAINT IF EXISTS system_type_events_systemtypecrossref_fk;
ALTER TABLE hat.locations_locationthingcrossref DROP CONSTRAINT IF EXISTS thing_id_refs_id_fk;
ALTER TABLE hat.locations_locationthingcrossref DROP CONSTRAINT IF EXISTS locations_locationthingcrossref_location_id_fkey;
ALTER TABLE hat.locations_locationthingcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_locations_locationthingcrossref_fk;
ALTER TABLE hat.locations_locationtolocationcrossref DROP CONSTRAINT IF EXISTS locations_locationtolocationcrossref_loc_one_id_fkey;
ALTER TABLE hat.locations_locationtolocationcrossref DROP CONSTRAINT IF EXISTS locations_locationtolocationcrossref_loc_two_id_fkey;
ALTER TABLE hat.locations_locationtolocationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_locations_locationtolocationcrossr309;
ALTER TABLE hat.locations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS locations_location_locations_systempropertystaticcrossref_fk;
ALTER TABLE hat.locations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS system_property_locations_systempropertystaticcrossref_fk;
ALTER TABLE hat.locations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_record_locations_systempropertystaticcrossref_fk;
ALTER TABLE hat.locations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_field_locations_systempropertystaticcrossref_fk;
ALTER TABLE hat.locations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS property_record_locations_systempropertystaticcrossref_fk;
ALTER TABLE hat.locations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS locations_location_locations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.locations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS system_property_locations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.locations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS data_field_locations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.locations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS property_record_locations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.locations_systemtypecrossref DROP CONSTRAINT IF EXISTS locations_location_location_systemtypecrossref_fk;
ALTER TABLE hat.locations_systemtypecrossref DROP CONSTRAINT IF EXISTS system_type_location_systemtypecrossref_fk;
ALTER TABLE hat.organisations_organisationlocationcrossref DROP CONSTRAINT IF EXISTS locations_location_organisations_organisationlocationcrossre499;
ALTER TABLE hat.organisations_organisationlocationcrossref DROP CONSTRAINT IF EXISTS organisations_organisationlocationcrossref_organisation_id_fkey;
ALTER TABLE hat.organisations_organisationlocationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_organisations_organisationlocation278;
ALTER TABLE hat.organisations_organisationthingcrossref DROP CONSTRAINT IF EXISTS things_thing_organisations_organisationthingcrossref_fk;
ALTER TABLE hat.organisations_organisationthingcrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisations_organisationthingcr474;
ALTER TABLE hat.organisations_organisationthingcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_organisations_organisationthingcro825;
ALTER TABLE hat.organisations_organisationtoorganisationcrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisation_organisationtoorgani876;
ALTER TABLE hat.organisations_organisationtoorganisationcrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisation_organisationtoorgani645;
ALTER TABLE hat.organisations_organisationtoorganisationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_organisations_organisationtoorgani310;
ALTER TABLE hat.organisations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisations_systempropertydynam75;
ALTER TABLE hat.organisations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS system_property_organisations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.organisations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS data_field_organisations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.organisations_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS property_record_organisations_systempropertydynamiccrossref_fk;
ALTER TABLE hat.organisations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisations_systempropertystati434;
ALTER TABLE hat.organisations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS system_property_organisations_systempropertystaticcrossref_fk;
ALTER TABLE hat.organisations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_record_organisations_systempropertystaticcrossref_fk;
ALTER TABLE hat.organisations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_field_organisations_systempropertystaticcrossref_fk;
ALTER TABLE hat.organisations_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS property_record_organisations_systempropertystaticcrossref_fk;
ALTER TABLE hat.organisations_systemtypecrossref DROP CONSTRAINT IF EXISTS organisations_organisation_organisations_systemtypecrossref_fk;
ALTER TABLE hat.organisations_systemtypecrossref DROP CONSTRAINT IF EXISTS system_type_organisations_systemtypecrossref_fk;
ALTER TABLE hat.people_personlocationcrossref DROP CONSTRAINT IF EXISTS locations_locationpersoncrossref_location_id_fkey;
ALTER TABLE hat.people_personlocationcrossref DROP CONSTRAINT IF EXISTS person_id_refs_id;
ALTER TABLE hat.people_personlocationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_people_personlocationcrossref_fk;
ALTER TABLE hat.people_personorganisationcrossref DROP CONSTRAINT IF EXISTS organisation_id_refs_id_fk;
ALTER TABLE hat.people_personorganisationcrossref DROP CONSTRAINT IF EXISTS person_id_refs_id_fk;
ALTER TABLE hat.people_personorganisationcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_people_personorganisationcrossref_fk;
ALTER TABLE hat.people_persontopersoncrossref DROP CONSTRAINT IF EXISTS people_persontopersoncrossref_person_one_id_fkey;
ALTER TABLE hat.people_persontopersoncrossref DROP CONSTRAINT IF EXISTS people_persontopersoncrossref_person_two_id_fkey;
ALTER TABLE hat.people_persontopersoncrossref DROP CONSTRAINT IF EXISTS relationship_type_id_refs_id_fk;
ALTER TABLE hat.people_persontopersoncrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_people_persontopersoncrossref_fk;
ALTER TABLE hat.people_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS people_person_people_systempropertydynamiccrossref_fk;
ALTER TABLE hat.people_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS system_property_people_systempropertydynamiccrossref_fk;
ALTER TABLE hat.people_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS data_field_people_systempropertydynamiccrossref_fk;
ALTER TABLE hat.people_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS property_record_people_systempropertydynamiccrossref_fk;
ALTER TABLE hat.people_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS people_person_people_systempropertystaticcrossref_fk;
ALTER TABLE hat.people_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS system_property_people_systempropertystaticcrossref_fk;
ALTER TABLE hat.people_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_record_people_systempropertystaticcrossref_fk;
ALTER TABLE hat.people_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_field_people_systempropertystaticcrossref_fk;
ALTER TABLE hat.people_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS property_record_people_systempropertystaticcrossref_fk;
ALTER TABLE hat.people_systemtypecrossref DROP CONSTRAINT IF EXISTS people_person_people_systemtypecrossref_fk;
ALTER TABLE hat.people_systemtypecrossref DROP CONSTRAINT IF EXISTS system_type_people_systemtypecrossref_fk;
ALTER TABLE hat.things_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS things_systempropertydynamiccrossref_fk;
ALTER TABLE hat.things_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS system_property_things_systempropertydynamiccrossref_fk;
ALTER TABLE hat.things_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS data_field_things_systempropertydynamiccrossref_fk;
ALTER TABLE hat.things_systempropertydynamiccrossref DROP CONSTRAINT IF EXISTS property_record_things_systempropertydynamiccrossref_fk;
ALTER TABLE hat.system_typetotypecrossref DROP CONSTRAINT IF EXISTS system_type_system_typetotypecrossref_fk;
ALTER TABLE hat.system_typetotypecrossref DROP CONSTRAINT IF EXISTS system_type_system_typetotypecrossref_fk1;
ALTER TABLE hat.things_thingtothingcrossref DROP CONSTRAINT IF EXISTS thing_one_id_refs_id_fk;
ALTER TABLE hat.things_thingtothingcrossref DROP CONSTRAINT IF EXISTS thing_two_id_refs_id_fk;
ALTER TABLE hat.things_thingtothingcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_things_thingtothingcrossref_fk;
ALTER TABLE hat.things_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS things_thingstaticpropertycrossref_thing_id_fkey;
ALTER TABLE hat.things_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS thing_property_id_refs_id_fk;
ALTER TABLE hat.things_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_record_things_systempropertycrossref_fk;
ALTER TABLE hat.things_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS data_field_things_systempropertystaticcrossref_fk;
ALTER TABLE hat.things_systempropertystaticcrossref DROP CONSTRAINT IF EXISTS property_record_things_systempropertystaticcrossref_fk;
ALTER TABLE hat.things_thingpersoncrossref DROP CONSTRAINT IF EXISTS owner_id_refs_id;
ALTER TABLE hat.things_thingpersoncrossref DROP CONSTRAINT IF EXISTS things_thingpersoncrossref_thing_id_fkey;
ALTER TABLE hat.things_thingpersoncrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_things_thingpersoncrossref_fk;
ALTER TABLE hat.system_relationshiprecordtorecordcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_system_relationshiprecordtorecordc567;
ALTER TABLE hat.system_relationshiprecordtorecordcrossref DROP CONSTRAINT IF EXISTS system_relationshiprecord_system_relationshiprecordtorecordc18;
ALTER TABLE hat.things_systemtypecrossref DROP CONSTRAINT IF EXISTS things_systemtypecrossref_fk;
ALTER TABLE hat.things_systemtypecrossref DROP CONSTRAINT IF EXISTS system_type_things_systemtypecrossref_fk;
ALTER TABLE hat.entity DROP CONSTRAINT IF EXISTS locations_location_entity_fk;
ALTER TABLE hat.entity DROP CONSTRAINT IF EXISTS things_thing_entity_fk;
ALTER TABLE hat.entity DROP CONSTRAINT IF EXISTS events_event_entity_fk;
ALTER TABLE hat.entity DROP CONSTRAINT IF EXISTS organisations_organisation_entity_fk;
ALTER TABLE hat.entity DROP CONSTRAINT IF EXISTS people_person_entity_fk;
ALTER TABLE hat.bundle_context_entity_selection DROP CONSTRAINT IF EXISTS entity_selection_bundle_context_fk;
ALTER TABLE hat.bundle_context_entity_selection DROP CONSTRAINT IF EXISTS entity_entity_selection_fk;
ALTER TABLE hat.system_property DROP CONSTRAINT IF EXISTS system_type_system_property_fk;
ALTER TABLE hat.system_property DROP CONSTRAINT IF EXISTS system_unitofmeasurement_system_property_fk;
DROP TABLE IF EXISTS hat.bundle_context_property_selection;
DROP TABLE IF EXISTS hat.bundle_context_to_bundle_crossref CASCADE;
DROP TABLE IF EXISTS hat.events_eventlocationcrossref;
DROP TABLE IF EXISTS hat.events_eventorganisationcrossref;
DROP TABLE IF EXISTS hat.events_eventpersoncrossref;
DROP TABLE IF EXISTS hat.events_eventthingcrossref;
DROP TABLE IF EXISTS hat.events_eventtoeventcrossref;
DROP TABLE IF EXISTS hat.events_systempropertydynamiccrossref;
DROP TABLE IF EXISTS hat.events_systempropertystaticcrossref;
DROP TABLE IF EXISTS hat.events_systemtypecrossref;
DROP TABLE IF EXISTS hat.locations_locationthingcrossref;
DROP TABLE IF EXISTS hat.locations_locationtolocationcrossref;
DROP TABLE IF EXISTS hat.locations_systempropertystaticcrossref;
DROP TABLE IF EXISTS hat.locations_systempropertydynamiccrossref;
DROP TABLE IF EXISTS hat.locations_systemtypecrossref;
DROP TABLE IF EXISTS hat.organisations_organisationlocationcrossref;
DROP TABLE IF EXISTS hat.organisations_organisationthingcrossref;
DROP TABLE IF EXISTS hat.organisations_organisationtoorganisationcrossref;
DROP TABLE IF EXISTS hat.organisations_systempropertydynamiccrossref;
DROP TABLE IF EXISTS hat.organisations_systempropertystaticcrossref;
DROP TABLE IF EXISTS hat.organisations_systemtypecrossref;
DROP TABLE IF EXISTS hat.people_personlocationcrossref;
DROP TABLE IF EXISTS hat.people_personorganisationcrossref;
DROP TABLE IF EXISTS hat.people_persontopersoncrossref;
DROP TABLE IF EXISTS hat.people_systempropertydynamiccrossref;
DROP TABLE IF EXISTS hat.people_systempropertystaticcrossref;
DROP TABLE IF EXISTS hat.people_systemtypecrossref;
DROP TABLE IF EXISTS hat.things_systempropertydynamiccrossref;
DROP TABLE IF EXISTS hat.system_typetotypecrossref;
DROP TABLE IF EXISTS hat.things_thingtothingcrossref;
DROP TABLE IF EXISTS hat.things_systempropertystaticcrossref;
DROP TABLE IF EXISTS hat.things_thingpersoncrossref;
DROP TABLE IF EXISTS hat.system_relationshiprecordtorecordcrossref;
DROP TABLE IF EXISTS hat.things_systemtypecrossref;
DROP TABLE IF EXISTS hat.entity CASCADE;
DROP TABLE IF EXISTS hat.bundle_context_entity_selection;
DROP TABLE IF EXISTS hat.system_property;
DROP TABLE IF EXISTS hat.bundle_context CASCADE;
DROP TABLE IF EXISTS hat.events_event;
DROP TABLE IF EXISTS hat.locations_location;
DROP TABLE IF EXISTS hat.organisations_organisation;
DROP TABLE IF EXISTS hat.people_person;
DROP TABLE IF EXISTS hat.people_persontopersonrelationshiptype;
DROP TABLE IF EXISTS hat.system_relationshiprecord;
DROP TABLE IF EXISTS hat.system_propertyrecord;
DROP TABLE IF EXISTS hat.system_unitofmeasurement;
DROP TABLE IF EXISTS hat.system_type;
DROP TABLE IF EXISTS hat.things_thing;
--changeset hubofallthings:sheFunctionDefinitions context:structuresonly

CREATE TABLE hat.she_function (
  name VARCHAR      NOT NULL PRIMARY KEY,
  description    VARCHAR   NOT NULL,
  trigger     JSONB      NOT NULL,
  enabled   BOOLEAN NOT NULL,
  bundle_id      VARCHAR   NOT NULL REFERENCES hat.data_bundles (bundle_id),
  last_execution TIMESTAMPTZ
);

--rollback DROP TABLE hat.she_function;

--changeset hubofallthings:hatapp context:data,testdata runOnChange:true

DELETE FROM hat.applications WHERE title = 'HAT';
INSERT INTO hat.applications (title, description, namespace, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('HAT', 'The HAT App ', 'hat', '/assets/images/Rumpel-logo.svg',
        'hatapp://hatapphost', '', TRUE,
        'app', TRUE, TRUE);

--changeset hubofallthings:shefeed context:data,testdata runOnChange:true

INSERT INTO hat.data_bundles (bundle_id, bundle) VALUES ('data-feed-direct-mapper', '{
  "twitter": {
    "orderBy": "lastUpdated",
    "endpoints": [
      {
        "endpoint": "twitter/tweets"
      }
    ]
  },
  "calendar": {
    "orderBy": "created",
    "endpoints": [
      {
        "filters": [],
        "endpoint": "calendar/google/events"
      },
      {
        "filters": [],
        "endpoint": "calendar/google/events"
      }
    ]
  },
  "fitbit/sleep": {
    "orderBy": "endTime",
    "endpoints": [
      {
        "endpoint": "fitbit/sleep"
      }
    ]
  },
  "facebook/feed": {
    "orderBy": "created_time",
    "endpoints": [
      {
        "endpoint": "facebook/feed"
      }
    ]
  },
  "fitbit/weight": {
    "orderBy": "date",
    "endpoints": [
      {
        "endpoint": "fitbit/weight"
      }
    ]
  },
  "facebook/events": {
    "orderBy": "start_time",
    "endpoints": [
      {
        "endpoint": "facebook/events"
      }
    ]
  },
  "fitbit/activity": {
    "orderBy": "originalStartTime",
    "endpoints": [
      {
        "endpoint": "fitbit/activity"
      }
    ]
  },
  "fitbit/activity/day/summary": {
    "orderBy": "dateCreated",
    "endpoints": [
      {
        "endpoint": "fitbit/activity/day/summary"
      }
    ]
  }
}')
ON CONFLICT DO NOTHING;

INSERT INTO hat.she_function (name, description, trigger, enabled, bundle_id, last_execution) VALUES
  ('data-feed-direct-mapper', '', '{
    "triggerType": "individual"
  }', TRUE, 'data-feed-direct-mapper', NULL)
ON CONFLICT (name)
  DO UPDATE
    SET description = '',
      trigger       = '{
        "triggerType": "individual"
      }',
      enabled       = TRUE,
      bundle_id     = 'data-feed-direct-mapper';

INSERT INTO hat.user_user
VALUES ('13609abc-dcae-432d-9ff8-a0aa2e2d899e', now(), now(), 'she',
        '$2a$12$llhjdJl8O9agrIsWX1T4/OuDoBdhQG1WeI65d6BUJQf5kfJrjRsJy', 'Smart HAT Engine', 't')
ON CONFLICT DO NOTHING;

INSERT INTO hat.user_role (user_id, role, extra)
VALUES ('13609abc-dcae-432d-9ff8-a0aa2e2d899e', 'platform', NULL)
ON CONFLICT DO NOTHING;

INSERT INTO hat.data_json (record_id, source, owner, date, data, hash) VALUES
  ('6bf8a89a-2692-4f00-9f2c-0b251ed1820b', 'she/feed', (SELECT user_id
                                                        FROM hat.user_user
                                                        WHERE email = 'she'
                                                        LIMIT 1), now(),
   jsonb_set(
       jsonb_set('{
         "date": {
           "iso": "2017-11-12T14:48:13.000+00:00",
           "unix": 1510498093
         },
         "title": {
           "text": "HAT Private Micro-server created",
           "action": "she"
         },
         "types": [
           "she"
         ],
         "source": "she",
         "content": {
           "text": "Digital Citizenship on the Internet is about the freedom of having our own persona(s) with the data we are able to claim, control and share. You now have a HAT micro-server to do that. Congratulations!",
           "media": [
             {
               "url": "https://developers.hubofallthings.com/images/firstimage.13d7.jpg"
             }
           ]
         }
       }',
                 '{date,iso}', to_jsonb(to_char(now() :: TIMESTAMP AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')),
                 TRUE),
       '{date,unix}', to_jsonb(extract(EPOCH FROM now())), TRUE)
    , E'\\x8513402516BB6F644A9D7C319765FB326AEBF2EAECA05F1B5C0AD77920A87A9C')
ON CONFLICT DO NOTHING;


--changeset hubofallthings:convertProfileDateMillisToSeconds context:data

UPDATE hat.data_json
SET data = data || CONCAT('{"dateCreated":', (data ->> 'dateCreated')::INT8 / 1000, '}')::jsonb
WHERE source = 'rumpel/profile'
      AND (data ->> 'dateCreated') NOT LIKE '%-%-%'
      AND (data ->> 'dateCreated')::INT8 > 1500000000000;
SELECT * FROM hat.data_json;

--changeset hubofallthings:notablesapp context:data

DELETE FROM hat.applications WHERE title = 'Notables';
INSERT INTO hat.applications (title, description, namespace, logo_url, url, auth_url, browser, category, setup, login_available)
VALUES ('Notables', 'Notables App for your private and social thought sharing', 'rumpel', '/assets/images/Rumpel-logo.svg',
        'notables://notablesapphost', '', TRUE,
        'app', TRUE, TRUE);

--changeset hubofallthings:applicationStatus context:structuresonly

CREATE TABLE hat.application_status (
  id      VARCHAR NOT NULL PRIMARY KEY,
  version VARCHAR NOT NULL,
  enabled BOOLEAN NOT NULL
)

--rollback DROP TABLE hat.application_status;

--changeset hubofallthings:dataDebitsExtras context:structuresonly

INSERT INTO hat.user_role (user_id, role, extra)
    SELECT client_id, 'datadebit', data_debit_key::VARCHAR FROM hat.data_debit_contract;

DROP TABLE hat.stats_data_debit_cless_bundle_records;
DROP TABLE hat.stats_data_debit_data_field_access;
DROP TABLE hat.stats_data_debit_data_table_access;
DROP TABLE hat.stats_data_debit_record_count;
DROP TABLE hat.stats_data_debit_operation;
DROP TABLE hat.data_debit;

CREATE TABLE hat.data_debit (
  data_debit_key          VARCHAR   NOT NULL PRIMARY KEY,
  date_created            TIMESTAMP NOT NULL,
  request_client_name     VARCHAR   NOT NULL,
  request_client_url      VARCHAR   NOT NULL,
  request_client_logo_url VARCHAR   NOT NULL,
  request_application_id  VARCHAR,
  request_description     VARCHAR
);

CREATE SEQUENCE hat.data_debit_permissions_sequence;

CREATE TABLE hat.data_debit_permissions (
  permissions_id       INTEGER   NOT NULL DEFAULT nextval('hat.data_debit_permissions_sequence') PRIMARY KEY,
  data_debit_key       VARCHAR   NOT NULL REFERENCES hat.data_debit (data_debit_key),
  date_created         TIMESTAMP NOT NULL,
  purpose              VARCHAR   NOT NULL,
  start                TIMESTAMP NOT NULL,
  period               INT8 NOT NULL,
  cancel_at_period_end BOOLEAN   NOT NULL,
  canceled_at          TIMESTAMP,
  terms_url            VARCHAR   NOT NULL,
  bundle_id            VARCHAR   NOT NULL REFERENCES hat.data_bundles (bundle_id),
  conditions           VARCHAR REFERENCES hat.data_bundles (bundle_id),
  accepted             BOOLEAN   NOT NULL
);

INSERT INTO hat.data_debit
(data_debit_key, date_created, request_client_name, request_client_url, request_client_logo_url, request_application_id, request_description)
  SELECT
    data_debit_key,
    date_created,
    '',
    '',
    '',
    NULL,
    NULL
  FROM hat.data_debit_contract;

INSERT INTO hat.data_debit_permissions
(data_debit_key, date_created, purpose, start, period, cancel_at_period_end, canceled_at, terms_url, bundle_id, conditions, accepted)
  SELECT
    data_debit_key,
    date_created,
    '',
    start_date,
    extract(EPOCH FROM end_date - start_date) :: INT8,
    NOT (rolling),
    NULL,
    '',
    bundle_id,
    conditions,
    enabled
  FROM hat.data_debit_bundle;


--changeset hubofallthings:sheFunctionHeadline context:structuresonly

ALTER TABLE hat.she_function ADD COLUMN headline VARCHAR NOT NULL DEFAULT('');



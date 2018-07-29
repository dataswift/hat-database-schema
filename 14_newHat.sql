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

--changeset hubofallthings:sheFunctionEnableCounter context:data

INSERT INTO hat.data_bundles (bundle_id, bundle) VALUES ('data-feed-counter', '{
        "monzo/transactions": {
            "endpoints": [
                {
                    "endpoint": "monzo/transactions"
                }
            ],
            "orderBy": "created",
            "ordering": "descending"
        },
        "calendar/google/events": {
            "endpoints": [
                {
                    "endpoint": "calendar/google/events",
                    "filters": []
                },
                {
                    "endpoint": "calendar/google/events",
                    "filters": []
                }
            ],
            "orderBy": "start.dateTime",
            "ordering": "descending"
        },
        "notables/feed": {
            "endpoints": [
                {
                    "endpoint": "rumpel/notablesv1"
                }
            ],
            "orderBy": "created_time",
            "ordering": "descending"
        },
        "fitbit/activity": {
            "endpoints": [
                {
                    "endpoint": "fitbit/activity"
                }
            ],
            "orderBy": "originalStartTime",
            "ordering": "descending"
        },
        "twitter/tweets": {
            "endpoints": [
                {
                    "endpoint": "twitter/tweets"
                }
            ],
            "orderBy": "lastUpdated",
            "ordering": "descending"
        },
        "fitbit/sleep": {
            "endpoints": [
                {
                    "endpoint": "fitbit/sleep"
                }
            ],
            "orderBy": "endTime",
            "ordering": "descending"
        },
        "spotify/feed": {
            "endpoints": [
                {
                    "endpoint": "spotify/feed"
                }
            ],
            "orderBy": "played_at",
            "ordering": "descending"
        },
        "facebook/feed": {
            "endpoints": [
                {
                    "endpoint": "facebook/feed"
                }
            ],
            "orderBy": "created_time",
            "ordering": "descending"
        },
        "fitbit/weight": {
            "endpoints": [
                {
                    "endpoint": "fitbit/weight"
                }
            ],
            "orderBy": "date",
            "ordering": "descending"
        }
}')
ON CONFLICT DO NOTHING;

INSERT INTO hat.she_function (name, description, headline, trigger, enabled, bundle_id, last_execution) VALUES
  ('data-feed-counter',
   'The Weekly Summary show your weekly activities. Weekly summary is private to you, but shareable as data.\n\nWeekly summary is powered by SHE, the Smart HAT Engine, the part of your HAT microserver that can install pre-trained analytics and algorithmic functions and outputs the results privately into your HAT.',
   'A summary of your week''s digital activities', '{
    "triggerType": "periodic", "period": "P1W"
  }', TRUE, 'data-feed-counter', NULL)
ON CONFLICT (name)
  DO UPDATE
    SET description = 'The Weekly Summary show your weekly activities. Weekly summary is private to you, but shareable as data.\n\nWeekly summary is powered by SHE, the Smart HAT Engine, the part of your HAT microserver that can install pre-trained analytics and algorithmic functions and outputs the results privately into your HAT.',
      headline = 'A summary of your week''s digital activities',
      trigger       = '{
        "triggerType": "periodic", "period": "P1W"
      }',
      enabled       = TRUE,
      bundle_id     = 'data-feed-counter';

--changeset hubofallthings:sheFunctionDataPreview context:structuresonly runOnChange:true

ALTER TABLE hat.she_function DROP COLUMN IF EXISTS data_preview;
ALTER TABLE hat.she_function ADD COLUMN data_preview JSONB;
ALTER TABLE hat.she_function DROP COLUMN IF EXISTS logo;
ALTER TABLE hat.she_function ADD COLUMN logo VARCHAR;

UPDATE hat.she_function SET
logo = 'url',
data_preview = '[
	{
        "source": "she",
        "date": {
            "iso": "2018-06-29T06:42:08.414Z",
            "unix": 1530254528
        },
        "types": [
            "insight",
            "activity"
        ],
        "title": {
            "text": "Your recent activity summary",
            "subtitle": "21 June 23:00 - 29 June 06:42 GMT",
            "action": "insight"
        },
        "content": {
            "text": "Twitter:\n  Tweets sent: 1\n\nFacebook:\n  Posts composed: 13\n",
            "nestedStructure": {
                "twitter": [
                    {
                        "content": "Tweets sent",
                        "badge": "1"
                    }
                ],
                "facebook": [
                    {
                        "content": "Posts composed",
                        "badge": "13"
                    }
                ]
            }
        }
    },
    {
        "source": "she",
        "date": {
            "iso": "2018-06-21T23:00:47.319Z",
            "unix": 1529622047
        },
        "types": [
            "insight",
            "activity"
        ],
        "title": {
            "text": "Your recent activity summary",
            "subtitle": "18 June 07:50 - 21 June 23:00 GMT",
            "action": "insight"
        },
        "content": {
            "text": "Twitter:\n  Tweets sent: 4\n\nFacebook:\n  Posts composed: 2\n\nNotables:\n  Notes taken: 4\n",
            "nestedStructure": {
                "twitter": [
                    {
                        "content": "Tweets sent",
                        "badge": "4"
                    }
                ],
                "facebook": [
                    {
                        "content": "Posts composed",
                        "badge": "2"
                    }
                ],
                "notables": [
                    {
                        "content": "Notes taken",
                        "badge": "4"
                    }
                ]
            }
        }
    }
]'
WHERE name = 'data-feed-counter';

--changeset hubofallthings:sheFunctionDataPreviewEndpoint context:structuresonly runOnChange:true

ALTER TABLE hat.she_function DROP COLUMN IF EXISTS data_preview_endpoint;
ALTER TABLE hat.she_function ADD COLUMN data_preview_endpoint VARCHAR;

UPDATE hat.she_function SET data_preview_endpoint = 'she/insights/activity-records' where name = 'data-feed-counter';

--changeset hubofallthings:sheFunctionScreenshots context:structuresonly runOnChange:true

ALTER TABLE hat.she_function DROP COLUMN IF EXISTS logo;

ALTER TABLE hat.she_function DROP COLUMN IF EXISTS graphics;
ALTER TABLE hat.she_function ADD COLUMN graphics JSONB;

UPDATE hat.she_function SET graphics =
'{
	"logo": {
		"normal": "https://static1.squarespace.com/static/5a71ebc8b1ffb68777ca627a/t/5acb4a166d2a73d3a00a10c6/1523272220659/HATAppsstore-rounded.png?format=300w"
	},
	"screenshots": [
		{
			"normal": "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/cb/01/56/cb0156b7-0cb6-128c-b1ec-fc3c7b31eb87/mzl.xfaethox.png/300x0w.jpg",
			"large": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/ac/a2/6b/aca26bb8-39dd-1cd9-159d-d37012ffbfeb/mzl.jiaxtegz.png/643x0w.jpg"
		},
		{
			"normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/26/b7/0f/26b70ffa-d9bc-2520-582b-b9a436eb00f5/pr_source.png/300x0w.jpg",
			"large": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/9b/2f/68/9b2f6853-ce11-a189-ae41-445e8e7b3248/mzl.fkcehkpp.png/643x0w.jpg"
		},
		{
			"normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/10/df/8f/10df8fae-b2b7-0c93-c530-d6338b1e6bc8/pr_source.png/300x0w.jpg",
			"large": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/28/de/7a/28de7aeb-54ed-6692-a63a-8102703361e2/pr_source.png/643x0w.png"
		},
		{
			"normal": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/15/94/30/159430c6-99fc-ee9f-72aa-d46d8436d76c/mzl.dvmpzlje.png/300x0w.jpg",
			"large": "https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/11/df/40/11df4050-582a-7598-fe02-b4421a4be818/pr_source.png/643x0w.png"
		}

	]
}'
WHERE name = 'data-feed-counter';

--changeset hubofallthings:sheFunctionName context:structuresonly runOnChange:true splitStatements:false

DO $$
BEGIN
  IF NOT EXISTS(SELECT * FROM information_schema.columns WHERE table_name = 'she_function' and column_name = 'id') THEN
    ALTER TABLE hat.she_function RENAME COLUMN "name" TO "id";
    ALTER TABLE hat.she_function ADD COLUMN name VARCHAR NOT NULL DEFAULT('');
  END IF;
END $$;

--changeset hubofallthings:uniquenessConstraints context:structuresonly

ALTER TABLE hat.data_json ADD COLUMN source_timestamp TIMESTAMPTZ;
ALTER TABLE hat.data_json ADD COLUMN source_unique_id VARCHAR;

CREATE UNIQUE INDEX data_json_source_unique ON hat.data_json (source, source_unique_id);

--changeset hubofallthings:sheFunctionRestructure context:structuresonly

CREATE TABLE hat.she_function_status (
  id                VARCHAR NOT NULL PRIMARY KEY,
  enabled           BOOLEAN NOT NULL,
  last_execution    TIMESTAMPTZ,
  execution_started TIMESTAMPTZ
);

INSERT INTO hat.she_function_status
(id, enabled, last_execution)
  SELECT
    id,
    enabled,
    last_execution
  FROM hat.she_function;

ALTER TABLE hat.she_function DROP COLUMN enabled;
ALTER TABLE hat.she_function DROP COLUMN last_execution;

ALTER TABLE hat.she_function ADD COLUMN version VARCHAR NOT NULL DEFAULT('1.0.0');
ALTER TABLE hat.she_function ALTER COLUMN description TYPE JSONB USING json_build_object('text',description);
ALTER TABLE hat.she_function ADD COLUMN terms_url VARCHAR NOT NULL DEFAULT('https://hatdex.org/terms-of-service-hat-owner-agreement');
ALTER TABLE hat.she_function ADD COLUMN developer_id VARCHAR NOT NULL DEFAULT('hatdex');
ALTER TABLE hat.she_function ADD COLUMN developer_name VARCHAR NOT NULL DEFAULT('HATDeX');
ALTER TABLE hat.she_function ADD COLUMN developer_url VARCHAR NOT NULL DEFAULT('https://hatdex.org');
ALTER TABLE hat.she_function ADD COLUMN developer_country VARCHAR;

UPDATE hat.she_function SET name = 'Weekly Summary' WHERE id = 'data-feed-counter';
UPDATE hat.she_function SET name = 'Feed mapper' WHERE id = 'data-feed-direct-mapper';

UPDATE hat.she_function SET graphics = json_build_object(
    'logo', graphics -> 'logo',
    'screenshots', graphics -> 'screenshots',
    'banner', json_build_object('normal', '')
);

UPDATE hat.she_function SET graphics = json_build_object(
    'logo', json_build_object('normal', ''),
    'screenshots', json_build_array(),
    'banner', json_build_object('normal', '')
) WHERE id = 'data-feed-direct-mapper';

ALTER TABLE hat.she_function ALTER COLUMN graphics SET NOT NULL;

--changeset hubofallthings:sheFunctionGraphicsUpdate context:data runOnChange:true

UPDATE hat.she_function SET graphics =
'{
	"logo": {
		"normal": "https://static1.squarespace.com/static/5a71ebc8b1ffb68777ca627a/t/5acb4a166d2a73d3a00a10c6/1523272220659/HATAppsstore-rounded.png?format=300w"
	},
  "banner": {
		"normal": ""
	},
	"screenshots": [
		{
			"normal": "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/cb/01/56/cb0156b7-0cb6-128c-b1ec-fc3c7b31eb87/mzl.xfaethox.png/300x0w.jpg",
			"large": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/ac/a2/6b/aca26bb8-39dd-1cd9-159d-d37012ffbfeb/mzl.jiaxtegz.png/643x0w.jpg"
		},
		{
			"normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/26/b7/0f/26b70ffa-d9bc-2520-582b-b9a436eb00f5/pr_source.png/300x0w.jpg",
			"large": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/9b/2f/68/9b2f6853-ce11-a189-ae41-445e8e7b3248/mzl.fkcehkpp.png/643x0w.jpg"
		},
		{
			"normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/10/df/8f/10df8fae-b2b7-0c93-c530-d6338b1e6bc8/pr_source.png/300x0w.jpg",
			"large": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/28/de/7a/28de7aeb-54ed-6692-a63a-8102703361e2/pr_source.png/643x0w.png"
		},
		{
			"normal": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/15/94/30/159430c6-99fc-ee9f-72aa-d46d8436d76c/mzl.dvmpzlje.png/300x0w.jpg",
			"large": "https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/11/df/40/11df4050-582a-7598-fe02-b4421a4be818/pr_source.png/643x0w.png"
		}

	]
}'
WHERE id = 'data-feed-counter';

--changeset hubofallthings:sheFunctionMoreDetails context:structuresonly

ALTER TABLE hat.she_function ADD COLUMN version_release_date TIMESTAMPTZ;
UPDATE hat.she_function SET version_release_date = to_timestamp(1514808000);
ALTER TABLE hat.she_function ALTER COLUMN version_release_date SET NOT NULL; -- acrobatics to go around Slick's broken support for default timestamp values

ALTER TABLE hat.she_function ADD COLUMN developer_support_email VARCHAR NOT NULL DEFAULT('contact@hatdex.org');

--changeset hubofallthings:sheFunctionDeveloper context:data

ALTER TABLE hat.she_function ALTER COLUMN developer_name SET DEFAULT('HAT Data Exchange Ltd');

UPDATE hat.she_function
    SET developer_name = 'HAT Data Exchange Ltd'
    WHERE developer_name = 'HATDeX';

--changeset hubofallthings:hatAppEnabled context:data

INSERT INTO hat.application_status (id, version, enabled)
VALUES
  ('hatapp', '1.2.4', true),
  ('hatappstaging', '1.2.4', true)
ON CONFLICT DO NOTHING;

--changeset hubofallthings:sheRecreate context:structuresonly

DROP TABLE hat.she_function_status;
DROP TABLE hat.she_function;

CREATE TABLE hat.she_function
(
  id                      VARCHAR     NOT NULL PRIMARY KEY,
  description             JSONB       NOT NULL,
  trigger                 JSONB       NOT NULL,
  bundle_id               VARCHAR     NOT NULL REFERENCES hat.data_bundles (bundle_id),
  headline                VARCHAR     NOT NULL,
  data_preview            JSONB,
  data_preview_endpoint   VARCHAR,
  graphics                JSONB       NOT NULL,
  name                    VARCHAR     NOT NULL,
  version                 VARCHAR     NOT NULL,
  terms_url               VARCHAR     NOT NULL,
  developer_id            VARCHAR     NOT NULL,
  developer_name          VARCHAR     NOT NULL,
  developer_url           VARCHAR     NOT NULL,
  developer_country       VARCHAR,
  version_release_date    TIMESTAMPTZ NOT NULL,
  developer_support_email VARCHAR     NOT NULL
);

CREATE TABLE hat.she_function_status (
  id                VARCHAR NOT NULL PRIMARY KEY,
  enabled           BOOLEAN NOT NULL,
  last_execution    TIMESTAMPTZ,
  execution_started TIMESTAMPTZ
);

INSERT INTO hat.she_function (id, description, trigger, bundle_id, headline, name, version, terms_url, developer_id, developer_name, developer_url, developer_country, version_release_date, developer_support_email, data_preview, data_preview_endpoint, graphics)
VALUES ('data-feed-counter',
  '{"text": "The Weekly Summary show your weekly activities. Weekly summary is private to you, but shareable as data.\\n\\nWeekly summary is powered by SHE, the Smart HAT Engine, the part of your HAT microserver that can install pre-trained analytics and algorithmic functions and outputs the results privately into your HAT."}',
  '{
    "period": "P1W",
    "triggerType": "periodic"
  }', 'data-feed-counter', 'A summary of your week''s digital activities', 'Weekly Summary', '1.0.0',
  'https://hatdex.org/terms-of-service-hat-owner-agreement', 'hatdex', 'HAT Data Exchange Ltd', 'https://hatdex.org',
        null, '2018-01-01 12:00:00.000000', 'contact@hatdex.org',
        '[
        {
              "source": "she",
              "date": {
                  "iso": "2018-06-29T06:42:08.414Z",
                  "unix": 1530254528
              },
              "types": [
                  "insight",
                  "activity"
              ],
              "title": {
                  "text": "Your recent activity summary",
                  "subtitle": "21 June 23:00 - 29 June 06:42 GMT",
                  "action": "insight"
              },
              "content": {
                  "text": "Twitter:\n  Tweets sent: 1\n\nFacebook:\n  Posts composed: 13\n",
                  "nestedStructure": {
                      "twitter": [
                          {
                              "content": "Tweets sent",
                              "badge": "1"
                          }
                      ],
                      "facebook": [
                          {
                              "content": "Posts composed",
                              "badge": "13"
                          }
                      ]
                  }
              }
          },
          {
              "source": "she",
              "date": {
                  "iso": "2018-06-21T23:00:47.319Z",
                  "unix": 1529622047
              },
              "types": [
                  "insight",
                  "activity"
              ],
              "title": {
                  "text": "Your recent activity summary",
                  "subtitle": "18 June 07:50 - 21 June 23:00 GMT",
                  "action": "insight"
              },
              "content": {
                  "text": "Twitter:\n  Tweets sent: 4\n\nFacebook:\n  Posts composed: 2\n\nNotables:\n  Notes taken: 4\n",
                  "nestedStructure": {
                      "twitter": [
                          {
                              "content": "Tweets sent",
                              "badge": "4"
                          }
                      ],
                      "facebook": [
                          {
                              "content": "Posts composed",
                              "badge": "2"
                          }
                      ],
                      "notables": [
                          {
                              "content": "Notes taken",
                              "badge": "4"
                          }
                      ]
                  }
              }
          }
      ]',
      '/data/she/insights/activity-records',
        '{
          "logo": {
            "normal": "https://static1.squarespace.com/static/5a71ebc8b1ffb68777ca627a/t/5acb4a166d2a73d3a00a10c6/1523272220659/HATAppsstore-rounded.png?format=300w"
          },
          "banner": {
            "normal": ""
          },
          "screenshots": [
            {
              "normal": "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/cb/01/56/cb0156b7-0cb6-128c-b1ec-fc3c7b31eb87/mzl.xfaethox.png/300x0w.jpg",
              "large": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/ac/a2/6b/aca26bb8-39dd-1cd9-159d-d37012ffbfeb/mzl.jiaxtegz.png/643x0w.jpg"
            },
            {
              "normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/26/b7/0f/26b70ffa-d9bc-2520-582b-b9a436eb00f5/pr_source.png/300x0w.jpg",
              "large": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/9b/2f/68/9b2f6853-ce11-a189-ae41-445e8e7b3248/mzl.fkcehkpp.png/643x0w.jpg"
            },
            {
              "normal": "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/10/df/8f/10df8fae-b2b7-0c93-c530-d6338b1e6bc8/pr_source.png/300x0w.jpg",
              "large": "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/28/de/7a/28de7aeb-54ed-6692-a63a-8102703361e2/pr_source.png/643x0w.png"
            },
            {
              "normal": "https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/15/94/30/159430c6-99fc-ee9f-72aa-d46d8436d76c/mzl.dvmpzlje.png/300x0w.jpg",
              "large": "https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/11/df/40/11df4050-582a-7598-fe02-b4421a4be818/pr_source.png/643x0w.png"
            }

          ]
        }');

INSERT INTO hat.she_function_status (id, enabled, last_execution, execution_started)
VALUES ('data-feed-counter', true, null, null);


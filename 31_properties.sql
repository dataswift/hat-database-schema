--liquibase formatted sql

--changeset hubofallthings:boilerplateProperties-1 context:data

SET search_path TO hat,public;

--
-- Data for system types
--

-- Entity Types

-- Events
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'BusinessEvent', 'Business event');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'PublicationEvent',
        'A PublicationEvent corresponds indifferently to the event of publication for a CreativeWork of any type e.g. a broadcast event, an on-demand event, a book/journal publication via a variety of delivery media');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'BroadcastEvent', 'An over the air or online broadcast event');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SocialEvent', 'Social event');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SportsEvent', 'Sports event');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Flight', 'An airline flight');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES
  (now(), now(), 'ParcelDelivery', 'The delivery of a parcel either via the postal service or a commercial service');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Reservation',
        'Describes a reservation for travel, dining or an event. Some reservations require tickets');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'FoodEstablishmentReservation', 'A reservation to dine at a food-related business');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'OrderItem',
        'An order item is a line of an order. It includes the quantity and shipping details of a bought offer');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'CreativeWork',
        'The most generic kind of creative work, including books, movies, photographs, software programs, etc');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Blog', 'A blog');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Recipe', 'A recipe');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Review', 'A review of an item - for example, of a restaurant, movie, or store');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SoftwareApplication', 'A software application');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'TVSeries', 'CreativeWorkSeries dedicated to TV broadcast and associated online delivery');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Action',
        'An action performed by a direct agent and indirect participants upon a direct object. Optionally happens at a location with the help of an inanimate instrument. The execution of the action may produce a result. Specific action sub-type documentation specifies the exact expectation of each argument/role');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'MoveAction', 'The act of an agent relocating to a place');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'TravelAction',
        'The act of traveling from an fromLocation to a destination by a specified mode of transport, optionally with participants');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SearchActon', 'The act of searching for an object');

-- Location Types

INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'AdministrativeArea',
        'A geographical region, typically under the jurisdiction of a particular government');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'City', 'A city or town');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Country', 'A country');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'CivicStructure', 'A public structure, such as a town hall or concert hall');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Airpot', 'An airport');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'BusStop', 'A bus stop');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'BusStation', 'A bus station');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'EventVenue', 'An event venue');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'LocalBusiness',
        'A particular physical business or branch of an organisation. Examples of LocalBusiness include a restaurant, a particular branch of a restaurant chain, a branch of a bank, a medical practice, a club, a bowling alley, etc');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Residence', 'The place where a person lives');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Coordinate', 'Geographic Coordinate');

-- Organisation Types
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Airline', 'An organisation that provides flights for passengers');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Corporation', 'Organisation: A business corporation');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'EducationalOrganisation', 'An educational organisation');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'CollegeOrUniversity', 'A college, university, or other third-level educational institution');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'HighSchool', 'A high school');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'GovernmentOrganisation', 'A governmental organisation or agency');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'EducationalOrganization', 'An Educational organisation');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'NGO', 'Organization: Non-governmental Organization');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SportsOrganisation',
        'Represents the collection of all sports organisations, including sports teams, governing bodies, and sports associations');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'SportsTeam', 'Organisation: Sports team');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'PerformingGroup', 'A performance group, such as a band, an orchestra, or a circus');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Person', 'A person (alive, dead, undead, or fictional)');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Demand', 'A pointer to products or services sought by the organization or person (demand).');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'OfferCatalog', 'Indicates an OfferCatalog listing for this Organization, Person, or Service.');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'ProgramMembership',
        'An Organisation (or ProgramMembership) to which this Person or Organisation belongs');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'OwnershipInfo', 'Products owned by the organization or person');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Brand',
        'The brand(s) associated with a product or service, or the brand(s) maintained by an organisation or business person');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Invoice', 'Party placing the order or paying the invoice');

-- Property Types

INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'PriceSpecification', 'The total financial value');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'ImageObject', 'An image of the item. This can be a URL or a fully described ImageObject');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'URL',
        'URL of a reference Web page that unambiguously indicates the item''s identity. E.g. the URL of the item''s Wikipedia page, Freebase page, or official website');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'ContactPoint', 'A contact point for a person or organization.');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Date', 'Calendar Date');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Time', 'Time');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Date and Time', 'Date and Time');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Distance', 'The height/length/distance of the item');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Offer', 'A pointer to products or services offered by the organization or person');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Place', 'A somewhat fixed, physical extension');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'PostalAddress', 'Physical address of the item');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'QuantitativeValue', 'A quantitative (numerical) value');
INSERT INTO hat.system_type (date_created, last_updated, name, description)
VALUES (now(), now(), 'Text', 'A generic textual value');

-- SELECT setval('hat.system_type_id_seq', (SELECT max(id)+1 from hat.system_type), false);

--
-- Data for system types relationships
--

INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'BroadcastEvent'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PublicationEvent'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'FoodEstablishmentReservation'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Reservation'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Blog'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CreativeWork'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Recipe'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CreativeWork'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Review'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CreativeWork'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'SoftwareApplication'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CreativeWork'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'TVSeries'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CreativeWork'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'MoveAction'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Action'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'TravelAction'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Action'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'SearchActon'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Action'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'City'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'AdministrativeArea'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'AdministrativeArea'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Airpot'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CivicStructure'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'BusStop'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CivicStructure'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'BusStation'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CivicStructure'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'EventVenue'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CivicStructure'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CollegeOrUniversity'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'EducationalOrganisation'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'HighSchool'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'EducationalOrganisation'), 'subtype');
INSERT INTO hat.system_typetotypecrossref (date_created, last_updated, type_one_id, type_two_id, relationship_type)
VALUES (now(), now(),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'SportsTeam'),
        (SELECT id
         FROM hat.system_type
         WHERE name = 'SportsOrganisation'), 'subtype');

--
-- Data for system units of measurement
--

INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'number', 'a generic numerical value', NULL);

INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'none', 'no unit of measurement (plain text)', NULL);

-- Weight and Mass
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'tonne', 'measurement of weight ', 't');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'carat', 'measurement of weight ', 'ct');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'gram', 'measurement of weight ', 'g');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'milligram', 'measurement of weight ', 'mg');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'stone', 'measurement of weight', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'pound', 'measurement of weight ', 'lb');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'ounce', 'measurement of weight ', 'oz');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'kilogram', 'measurement of weight', 'kg');

-- Distance and length
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'mile', 'measurement of distance ', 'mi');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'kilometer', 'measurement of distance ', 'km');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'millimeter', 'measurement of height or length ', 'mm');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'foot', 'measurement of height or length ', 'ft');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'inch', 'measurement of height or length ', 'in');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'meter', 'measurement of height or length', 'm');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'centimeter', 'measurement of height or length', 'cm');

INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'longitude', 'Geographic Longitude', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'latitude', 'Geographic Latitude', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'longitude and latitude', 'Geographic Longitude and Latitude', NULL);

-- Time and date
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'month', 'measurement of time', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'week', 'measurement of time', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'day', 'measurement of time', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'hour', 'measurement of time', 'h');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'minute', 'measurement of time', 'min');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'second', 'measurement of time', 'min');

INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'date (ISO)', 'Standard (ISO 8601) Calendar Date (e.g. 2016-01-05)', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'time (ISO)', 'Standard (ISO 8601) Time (e.g. 07:08:08)', NULL);
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'dateTime (ISO)', 'Standard (ISO 8601) Calendar Date and Time (e.g. 2016-01-05T07:08:08Z)', NULL);

-- Major Currencies
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Euro', 'Currency', 'EUR');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'US Dollar', 'Currency', 'USD');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Japanese Yen', 'Currency', 'JPY');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Great British Pound', 'Currency', 'GBP');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Australian Dollar', 'Currency', 'AUD');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Swiss Franc', 'Currency', 'CHF');
INSERT INTO hat.system_unitofmeasurement (date_created, last_updated, name, description, symbol)
VALUES (now(), now(), 'Other Currency', 'Currency', NULL);

-- SELECT setval('hat.system_unitofmeasurement_id_seq', (SELECT max(id) + 1 FROM hat.system_unitofmeasurement), FALSE);


--
-- Data for system properties
--

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'First Name', 'First Name',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Text'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Last Name', 'Last Name',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Text'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Full Name', 'Full Name',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Text'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (kg)', 'weight in kilograms',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'kilogram'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (t)', 'weight in tonnes',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'tonne'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (ct)', 'weight in carats',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'carat'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (g)', 'weight in grams',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'gram'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (mg)', 'weight in milligrams',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'milligram'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (stone)', 'weight in stones',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'stone'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (lb)', 'weight in pounds',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'pound'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'weight (oz)', 'weight in ounces',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'QuantitativeValue'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'ounce'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'height (cm)', 'height in centimeters',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'centimeter'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'height (m)', 'height in meters',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'meter'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'height (in)', 'height in inches',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'inch'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'height (ft)', 'height in feet',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'foot'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (mi)', 'Distance in miles',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'mile'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (km)', 'Distance in kilometers',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'kilometer'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (mm)', 'Distance in millimeters',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'millimeter'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (ft)', 'Distance in feet',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'foot'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (in)', 'Distance in inches',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'inch'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (m)', 'Distance in meters',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'meter'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'distance (cm)', 'Distance in centimeters',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Distance'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'centimeter'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (Euro)', 'Price (Euro)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Euro'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (US Dollar)', 'Price (US Dollar)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'US Dollar'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (Japanese Yen)', 'Price (Japanese Yen)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Japanese Yen'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (British Pound)', 'Price (British Pound)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Great British Pound'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (Australian Dollar)', 'Price (Australian Dollar)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Australian Dollar'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price (Swiss Franc)', 'Price (Swiss Franc)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Swiss Franc'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Price', 'Price',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PriceSpecification'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'Other Currency'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Internet Address (URL)', 'Internet Address (URL)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'URL'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Image Address (URL)', 'Image Address (URL)',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'ImageObject'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Contact Point', 'Contact Point',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'ContactPoint'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Date', 'Date',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Date'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'date (ISO)'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Date and Time', 'Date and Time',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Date and Time'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'dateTime (ISO)'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Time', 'Time',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Time'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'time (ISO)'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Location Longitude', 'Location Longitude',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Place'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'longitude'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Location Latitude', 'Location Latitude',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Place'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'latitude'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Location Country', 'Location Country',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Geo Location', 'Geo Location',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Place'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'longitude and latitude'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Country of Residence', 'Country of Residence',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Country of Birth', 'Country of Birth',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Citizenship', 'Citizenship',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Current Country', 'Current Country',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Country'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Location Address', 'Location Address',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'PostalAddress'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'School', 'School',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'EducationalOrganization'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
VALUES (now(), now(), 'High School', 'High School',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'High School'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'University/College', 'University or College',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'CollegeOrUniversity'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Contact Details', 'Contact Details',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'ContactPoint'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Product/Service Sought', 'Product/Service Sought',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Demand'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'Product/Service Offered', 'Product/Service Offered',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Offer'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));

INSERT INTO hat.system_property (date_created, last_updated, name, description, type_id, unitofmeasurement_id)
VALUES (now(), now(), 'other', 'other',
        (SELECT id
         FROM hat.system_type
         WHERE name = 'Text'),
        (SELECT id
         FROM hat.system_unitofmeasurement
         WHERE name = 'none'));
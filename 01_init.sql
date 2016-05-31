--liquibase formatted sql

--changeset hubofallthings:extensions context:structuresonly


-- ALTER DATABASE hat_template SET allowconn = FALSE;
-- ALTER DATABASE hat_template SET istemplate = TRUE;
CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION "pgcrypto";

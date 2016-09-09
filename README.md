# hat-database-schema
HAT Database Schema for sharing across the different projects using it

Setting up the environment:

    source env.sh

You can modify the database credentials by changing environment variables:

- DATABASE
- DBUSER
- DBPASS

Then run:

	./setupDatabase.sh
Which will setup the credentials and the required database extensions. 

Then run:

    ./setupAccess.sh
Which will setup the initial HAT Owner and HAT Access. This will generate a file `41_authentication.sql`, which is deleted for security reasons after the `applyEvolutions.sh` is run. Re-run this as needed. 

For further information, see below `#Setting Passwords`

Finally, execute (liquibase-based) database evolutions on the DB:

    ./applyEvolutions.sh -c structuresonly,data

The `-c` (or `--contexts`) option specifies which changesets to include. Currently there are 2: `structuresonly` for core data structures and `data` for important boilerplate data.

If you need to delete all contents of the database, you can do so by running:

    ./applyEvolutions.sh -t dropAll


# Setting Passwords
Default passwords can be overwritten via environment variables

For HAT Owner credentials, pass in *plain text* password to the variable `HAT_OWNER_PASSWORD`. It will automatically be hashed on installation.
You can also pass in the *hashed* version via the variable `HAT_OWNER_PASSWORD_HASH`

For example
`> HAT_OWNER_PASSWORD=bobplumberpassword ./setupAccess.sh`
`> HAT_OWNER_PASSWORD_HASH='$2a$10$VTnzSsdslsrlj1gVOGZQ7O3ze4KML/qG1stH8yC/ksFPTx8NoF0Ri' ./setupAccess.sh`

If both `HAT_OWNER_PASSWORD` and `HAT_OWNER_PASSWORD_HASH` are available, then the `HAT_OWNER_PASSWORD_HASH` takes priority

The same applies to Hat Platform Password
`HAT_PLATFORM_PASSWORD` vs `HAT_PLATFORM_PASSWORD_HASH`

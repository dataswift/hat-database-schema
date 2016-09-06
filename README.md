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

Finally, execute (liquibase-based) database evolutions on the DB:

    ./applyEvolutions.sh -c structuresonly,data

The `-c` (or `--contexts`) option specifies which changesets to include. Currently there are 2: `structuresonly` for core data structures and `data` for important boilerplate data.

If you need to delete all contents of the database, you can do so by running:

    ./applyEvolutions.sh -t dropAll

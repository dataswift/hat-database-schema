FROM library/postgres
ADD *.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_DB hat_template
ENV PGDATA /var/lib/postgresql/data
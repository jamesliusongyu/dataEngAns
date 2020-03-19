FROM ubuntu:16.04

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres


# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER dba WITH SUPERUSER PASSWORD 'govtech';" &&\
    createdb -O dba cars 

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE TABLE IF NOT EXISTS car_dim (car_id UUID PRIMARY KEY, serial_number VARCHAR(255), model_name VARCHAR(100), model_variant VARCHAR(100), isNewCondition VARCHAR(1), weight INTEGER, engine_cubic_capcity INTEGER, price INTEGER, customer VARCHAR(255), manufacturer VARCHAR(255));"

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE TABLE IF NOT EXISTS sales_dim (sales_id serial PRIMARY KEY,  customer VARCHAR(255), customer_phone VARCHAR(100), salesperson VARCHAR(255) );"

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE TABLE IF NOT EXISTS car_transaction_fact (sales_id SERIAL REFERENCES sales_dim(sales_id), car_id UUID REFERENCES car_dim(car_id), date DATE NOT NULL, time TIME NOT NULL);"
#stores phone as varchar because 11-11-11 etc





# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/us

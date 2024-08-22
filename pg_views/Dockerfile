FROM ghcr.io/cloudnative-pg/postgresql:16-bookworm

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres

USER root

# Install build dependencies and pg_cron
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    postgresql-server-dev-16 \
    postgresql-16-cron

# Configure PostgreSQL for pg_cron
RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "cron.database_name = 'postgres'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "cron.timezone = 'GMT'" >> /usr/share/postgresql/postgresql.conf.sample

# Clone the pg_ivm repository
RUN git clone https://github.com/sraoss/pg_ivm.git /pg_ivm

# Build and install the pg_ivm extension
WORKDIR /pg_ivm
RUN make && make install

# Switch back to the default directory
WORKDIR /

USER 26

# Expose the PostgreSQL port
EXPOSE 5432

# Start PostgreSQL server
CMD ["postgres"]
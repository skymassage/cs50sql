-- Demonstrates navigating a PostgreSQL database

-- Starts PostgreSQL server using Docker (note that go the "cs50sql" folder).
docker run --name postgres -p 80:5432 -v $(pwd)/wk6_scaling:/mnt:ro -e POSTGRES_PASSWORD=123 -d postgres
docker run --name postgres -p 5432:5432 -v $(pwd)/wk6_scaling:/mnt:ro -e POSTGRES_PASSWORD=123 -d postgres

-- Start docker container
docker start postgres

-- Logs in, if using '123' as password
docker exec -it postgres psql postgresql://postgres@127.0.0.1:5432/postgres

-- Lists all databases
\l
\list

-- Connects to a particular database
\c <database>
\connect <database>

-- Lists all tables
\dt

-- Describes a particular table
\d <table>

-- Quits
\q

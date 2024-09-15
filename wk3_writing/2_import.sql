--------------------------------------------------------------- Create or open mfa.db and create the table
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";

CREATE TABLE IF NOT EXISTS "collections"(
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);
---------------------------------------------------------------

-- Data could also be stored in a comma-separated values format, or CSV. 

-- Demonstrates importing a CSV into an existing table.

-- Use the SQLite (not SQL) command to imports into an existing table by specifying mode and skipping header columns.
.import --csv --skip 1 mfa_id.csv collections
-- The first argument, "--csv" indicates to SQLite that we are importing a CSV file. 
-- This will help SQLite parse the file correctly. 
-- The second argument, "--skip 1" indicates that the first row of the CSV file (the header row) is skipped,
-- or not inserted into the table, because we've created the table with colunm names.
-- Note that here we don't need the double quotes "" for collections,
-- i.e., there is no need to set "collections" because this is a SQLite statement not a SQL statement.
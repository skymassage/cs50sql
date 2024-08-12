--------------------------------------------------------------- Create or open mfa.db
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";
---------------------------------------------------------------

-- The CSV file we just imported contained primary key values ("id" = 1, 2, 3 etc.) for each row of data. 
-- We could import a CSV file without containing the ID or primary key values.

-- Demonstrates importing a CSV into an existing table and adding primary keys

-- To successfully import the CSV file without ID values or primary keys, we will to use a temporary table "temp":
.import --csv mfa_no_id.csv temp
-- Note that here we don't use the argument "--skip 1" with this command,
-- because the table we're going to insert haven't been created.
-- This is because SQLite is capable of recognizing the very first row of CSV data as the header row, 
-- and converts those into the column names of the new temp table.

-- Creates a final table to store imported data
CREATE TABLE IF NOT EXISTS "collections"(
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);


INSERT INTO "collections" ("title", "accession_number", "acquired") 
SELECT "title", "accession_number", "acquired" FROM "temp";

-- Remove the temporary table
DROP TABLE "temp";

-- While trying to insert multiple rows into a table, if even one of them violates a constraint, 
-- the insertion command will result in an error and none of the rows will be inserted.

-- Here one of the "acquired" values in the table is missing, i.e., empty and not NULL.
-- This was interpreted as text and hence, read into the table as an empty text value. 
-- We can run queries on the table after importing to convert these empty values into NULL if required.
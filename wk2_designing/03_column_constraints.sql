-- A column constraint is a type of constraint that applies to a specified column in the table.
-- SQLite has four column constraints:
-- CHECK: Allow checking for a condition, like all values in the column must be greater than 0
-- DEFAULT: Use a default value if none is supplied for a row
-- NOT NULL: Dictate that a null or empty value cannot be inserted into the column
-- UNIQUE: Dictate that every value in this column must be unique

-- Primary key columns and by extension, foreign key columns must always have unique values, 
-- so there is no need to explicitly specify the NOT NULL or UNIQUE for primary key or foreign key columns. 

--------------------------------------------------------------- Create or open mbta.db using sqlite3 mbta.db
-- Deletes prior tables if they exist
DROP TABLE IF EXISTS "riders";
DROP TABLE IF EXISTS "stations";
DROP TABLE IF EXISTS "visits";
DROP TABLE IF EXISTS "swipes";
DROP TABLE IF EXISTS "cards";

-- Adds UNIQUE, NOT NULL as column constraints

CREATE TABLE "riders" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,    -- Ensure the station name are specified and each station must have a unique name.
    "line" TEXT NOT NULL,           -- Ensure the line are specified.
    PRIMARY KEY("id")
);

CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER,
    FOREIGN KEY("rider_id") REFERENCES "riders"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);
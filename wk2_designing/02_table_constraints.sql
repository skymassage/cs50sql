
-- We can use table constraints "PRIMARY KEY" and "FOREIGN KEY" to impose restrictions on certain values in our tables.
-- "PRIMARY KEY" means a primary key column must have unique values.
-- "FOREIGN KEY" means a foreign key value must be found in the primary key column of the related table.

--------------------------------------------------------------- Create or open mbta.db using sqlite3 mbta.db
-- Deletes prior tables if they exist
DROP TABLE IF EXISTS "riders";
DROP TABLE IF EXISTS "stations";
DROP TABLE IF EXISTS "visits";
DROP TABLE IF EXISTS "swipes";
DROP TABLE IF EXISTS "cards";

-- Create two primary key columns, the ID for both "riders" and "stations" and then referenced these primary keys 
-- as foreign keys in the "visits" table.

CREATE TABLE "riders" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT,
    "line" TEXT,
    PRIMARY KEY("id")
);

-- In the "visits" table, there is no primary key. However, SQLite gives every table a primary key by default, 
-- known as the row ID. Even though the row ID is implicit, it can be queried.
CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER,
    FOREIGN KEY("rider_id") REFERENCES "riders"("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id")
);


-- It is also possible to create a primary key composed of two columns. 
-- For example, if we want to give "visits" a primary key composed of both the rider and stations IDs, we could use this syntax
-- CREATE TABLE visits (
--     "rider_id" INTEGER,
--     "station_id" INTEGER,
--     PRIMARY KEY("rider_id", "station_id")
-- );
-- Here we probably want to allow a rider to visit a station more than once, so we would not move ahead with this approach.
-- (Because PRIMARY KEY("rider_id", "station_id") is unique)
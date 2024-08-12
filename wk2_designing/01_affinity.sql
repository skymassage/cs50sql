-- A column can be specified the data type while creating a table.
-- However, columns in SQLite don't always store one particular data type. 
-- They are said to have type affinities, meaning that they try to convert an input value into the type they have an affinity for.
-- The five type affinities in SQLite are: 
-- 1. Text: characters or strings
-- 2. Numeric: either integer or real values based on what the input value best converts to
-- 3. Integer: numbers without decimal points
-- 4. Real: decimal or floating point numbers
-- 5. Blob: Binary Large Object, for storing objects in binary (useful for images, audio etc.)
-- Consider a column with a type affinity for Integers: If we try to insert a text "25" into this column,
-- it will be converted into an integer data type.
-- Similarly, inserting an integer 25 into a column with a type affinity for text will convert the number to its text equivalent, "25".
-- Note that SQLite don't has a type affinity for Boolean, but other DBMS's might have.
-- A workaround could be to use 0 or 1 integer values to represent booleans.
-- If we don't specify a type affinity of a column in SQLite, the default type affinity is numeric,
-- so the column would get assigned the numeric type affinity.

--------------------------------------------------------------- Create or open mbta.db using sqlite3 mbta.db
-- Deletes prior tables if they exist
-- Use DROP to delete prior tables if they exist
DROP TABLE IF EXISTS "riders";
DROP TABLE IF EXISTS "stations";
DROP TABLE IF EXISTS "visits";
DROP TABLE IF EXISTS "swipes";
DROP TABLE IF EXISTS "cards";

-- Adds type affinities

CREATE TABLE "riders" (
    "id" INTEGER,
    "name" TEXT
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT,
    "line" TEXT
);

CREATE TABLE "visits" (
    "rider_id" INTEGER,
    "station_id" INTEGER
);
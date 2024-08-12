--------------------------------------------------------------- Create or open mbta.db using sqlite3 mbta.db
-- Delete sprior tables if they exist
DROP TABLE IF EXISTS "riders";
DROP TABLE IF EXISTS "stations";
DROP TABLE IF EXISTS "visits";
DROP TABLE IF EXISTS "swipes";
DROP TABLE IF EXISTS "cards";

-- Use CHECK, DEFAULT as column constraints

CREATE TABLE "cards" (
    "id" INTEGER,
    PRIMARY KEY("id")
);

CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "line" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "swipes" (
    "id" INTEGER,
    "card_id" INTEGER,
    "station_id" INTEGER,
    "type" TEXT NOT NULL CHECK("type" IN ('enter', 'exit', 'deposit')),
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);
-- The "datetime" column is given the type affinity numeric - this is because numeric types can store and display date values.
-- The "CURRENT_TIMESTAMP" function returns the current date and time in UTC in the format YYYY-MM-DD HH:MM:SS.
-- A default value is assigned to the "datetime" column so that it automatically picks up the current timestamp in SQLite if none is supplied.

-- Implement the column constraint CHECK with an expression "amount" != 0 to the "amount" column to ensure the amount on a swipe is not 0.
-- Similarly, use CHECK to check on "type to ensure its value is one of "enter", "exit" and "deposit". Notice the use of the "IN" keyword to carry out this check.
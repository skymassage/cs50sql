--- Demonstrates PostgreSQL types

CREATE DATABASE "mbta";

CREATE TABLE "cards" (
    "id" SERIAL,
    PRIMARY KEY("id")
);
-- The type "SERIAL" is integer, but they are serial numbers, usually used for primary keys which auto increment for us.

CREATE TABLE "stations" (
    "id" SERIAL,
    "name" VARCHAR(32) NOT NULL UNIQUE,
    "line" VARCHAR(32) NOT NULL,
    PRIMARY KEY("id")
);
-- We can use VARCHAR in the same way as in MySQL.

-- Unlike MySQL, we can't directly specify "ENUM" as the type to the column.
-- We need to use "CREATE TYPE" and give this type some name, and then specify it to the column.
CREATE TYPE "swipe_type" AS ENUM('enter', 'exit', 'deposit');
CREATE TABLE "swipes" (
    "id" SERIAL,
    "card_id" INT,
    "station_id" INT,
    "type" "swipe_type" NOT NULL,
    "datetime" TIMESTAMP NOT NULL DEFAULT now(),
    "amount" NUMERIC(5,2) NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);
-- PostgreSQL has types "TIMESTAMP", "DATE", "TIME" and "INTERVAL" to represent date and time values,
-- where "INTERVAL" is used to capture how long something took, or the distance between times.
-- For the default timestamp, we use "now()" to give us the current timestamp.
-- Similar to MySQL, we can specify the precision with these types.
-- "NUMERIC(M, D)", where M is the maximum number of digits (the precision)
-- and D is the number of digits to the right of the decimal point (the scale).

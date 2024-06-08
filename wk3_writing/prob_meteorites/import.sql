DROP TABLE IF EXISTS "meteorites_temp";
DROP TABLE IF EXISTS "meteorites";
.import --csv meteorites.csv meteorites_temp
------------------------------------------------

-- Any empty values in meteorites.csv are represented by NULL in the meteorites table.
-- Keep in mind that the mass, year, lat, and long columns have empty values in the CSV.
UPDATE "meteorites_temp" SET "mass" = NULL WHERE "mass" = '';
UPDATE "meteorites_temp" SET "year" = NULL WHERE "year" = '';
UPDATE "meteorites_temp" SET "lat" = NULL WHERE "lat" = '';
UPDATE "meteorites_temp" SET "long" = NULL WHERE "long" = '';

-- All columns with decimal values (e.g., 70.4777) should be rounded to the nearest hundredths place
-- (e.g., 70.4777 becomes 70.48).
-- Keep in mind that the mass, lat, and long columns have decimal values.
UPDATE "meteorites_temp" SET "mass" = ROUND("mass", 2);
UPDATE "meteorites_temp" SET "lat" = ROUND("lat", 2);
UPDATE "meteorites_temp" SET "long" = ROUND("long", 2);

-- All meteorites with the nametype "Relict" are not included in the meteorites table.
DELETE FROM "meteorites_temp" WHERE "nametype" = 'Relict';

-- Sort the rows by year from oldest to newest, and if any rows belong to the same year, sort them alphabetically by name.
-- Based on this order, the ID should start at 1 from the first row.
CREATE TABLE IF NOT EXISTS "meteorites"(
    "id" INTEGER,
    "name" TEXT,
    "class" TEXT,
    "mass" NUMERIC,
    "discovery" TEXT,
    "year" NUMERIC,
    "lat" NUMERIC,
    "long" NUMERIC,
    PRIMARY KEY("id")
);

INSERT INTO "meteorites" ("name", "class", "mass", "discovery", "year", "lat", "long")
SELECT "name", "class", "mass", "discovery", "year", "lat", "long" FROM "meteorites_temp" ORDER BY "year", "name";

DROP TABLE "meteorites_temp";

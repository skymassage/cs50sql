--------------------------------------------------------------- Create mfa.db and import votes.csv
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";

.import --csv votes.csv votes
---------------------------------------------------------------

-- Demonstrate cleaning data from a CSV of votes for favorite artwork

-- Count votes
SELECT "title", COUNT("title") FROM "votes" GROUP BY "title";
-- The result should display four titles, but it doesn't due to some typos in the titles.
-- We are going to fix it in the following queries.

-- Use "trim" to remove leading and trailing whitespace from a string.
UPDATE "votes" SET "title" = trim("title");

-- Use "upper" to convert the text to upper-case.
UPDATE "votes" SET "title" = upper("title");

-- Manually update the titles of "Farmers working at dawn".
UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" = 'FARMERS WORKING';
UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" = 'FAMERS WORKING AT DAWN';

-- Fix misspelling of "Farmers working at dawn". Note that "LIKE" is case-insensitive.
UPDATE "votes" SET "title" = 'FARMERS WORKING AT DAWN' WHERE "title" LIKE 'Fa%';

-- Fix misspellings of "Imaginative landscape".
UPDATE "votes" SET "title" = 'IMAGINATIVE LANDSCAPE' WHERE "title" LIKE 'Imag%';

-- Fix misspellings of "Profusion of flowers".
UPDATE "votes" SET "title" = 'PROFUSION OF FLOWERS' WHERE "title" LIKE 'Profusion%';

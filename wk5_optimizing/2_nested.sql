--------------------------------------------------------------- Open movies.db
DROP INDEX IF EXISTS "title_index";
DROP INDEX IF EXISTS "people_index";
DROP INDEX IF EXISTS "name_index";
DROP INDEX IF EXISTS "recents";
--------------------------------------------------------------- Demonstrates foreign key indexes

-- Time searching for movies Tom Hanks has starred in
.timer on
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
.timer off

-- Identify which columns we should create indexes on
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
QUERY PLAN
-- Output:
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SCAN stars
--    `--SCALAR SUBQUERY 1
--       `--SCAN people
-- This shows us that the query requires two scans of "people" and "stars". 
-- The table "movies" is not scanned because the query is utilizing the index on the primary key column,
-- which is provided automatically by SQLite when the primary key is of the INTEGER type affinity.
-- It is an efficient way to access rows directly if the query conditions involve a table's primary key.

-- Create the two indexes to speed the previous query up:
-- First create index on foreign key, and then create index to speed name look-ups
.timer on
CREATE INDEX "person_index" ON "stars" ("person_id");
CREATE INDEX "name_index" ON "people" ("name");
.timer off

-- Demonstrate the use of indexes
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Output:
-- QUERY PLAN
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SEARCH stars USING INDEX person_index (person_id=?)
--    `--SCALAR SUBQUERY 1
--       `--SEARCH people USING COVERING INDEX name_index (name=?)
-- All the scans are now searches using indexes.
-- The search on the table "people" uses something called "COVERING INDEX"

-- A covering index is an index that contains all the columns to be read,
-- which means that the data corresponding to the index entry doesn't need to be looked up in the table.
-- In other words, the query column should be covered by the index used.
-- Index generally has two steps to search: 1. Looking up relevant information in the index (covering index just includes this step).
--                                          2. Using the index to then search data in the table, 
--                                             a covering index means that we do our search in single step 

-- To have our search on the table "stars" also use a covering index, we can add "movie_id" to the index we created for stars.
-- This will ensure that the information being looked up (movie ID) and the value being searched on (person ID) are both be in the index.
-- First, drop the existing index "person_index" to use the same name in the following.
DROP INDEX "person_index";
-- We can create an index that includes the "movie_id" column as well and we can have indexes that span multiple columns.. 
CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");
-- Demonstrate that we now have two covering indexes.
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
-- Output:
-- QUERY PLAN
-- |--SEARCH movies USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 2
--    |--SEARCH stars USING COVERING INDEX person_index (person_id=?)
--    `--SCALAR SUBQUERY 1
--       `--SEARCH people USING COVERING INDEX name_index (name=?)
-- Search will be much faster becaue of two covering indexes.
.timer on
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" IN (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
.timer off
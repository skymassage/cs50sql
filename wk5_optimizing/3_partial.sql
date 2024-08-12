--------------------------------------------------------------- Open movies.db
DROP INDEX IF EXISTS "title_index";
DROP INDEX IF EXISTS "person_index";
DROP INDEX IF EXISTS "name_index";
DROP INDEX IF EXISTS "recents";
--------------------------------------------------------------- Demonstrates partial indexes

-- Partial index includes only a subset of rows from a table, allowing us to save some space that a full index would occupy.
-- This is especially useful when we know that users query only a subset of rows from the table.

-- Time searching for movies in 2023
.timer on
SELECT "title" FROM "movies" WHERE "year" = 2023;

-- Use the WHERE clasue to create a partial index to speed up searches involving 2023.
CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;

-- Rerun query with the partial index.
SELECT "title" FROM "movies" WHERE "year" = 2023;

-- Show query's usage of the partial index.
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2023;
-- QUERY PLAN
-- `--SCAN movies USING COVERING INDEX recents
-- Note that there is no difference in real time before and after indexing, since the result contains many rows,
-- We should observe that user time decreases after indexing.

-- Rerun query without the partial index to search for the movies in 1998 .
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 1998;
-- QUERY PLAN
-- `--SCAN movies
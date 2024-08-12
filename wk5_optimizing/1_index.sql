--------------------------------------------------------------- Open movies.db
DROP INDEX IF EXISTS "title_index";
DROP INDEX IF EXISTS "people_index";
DROP INDEX IF EXISTS "name_index";
DROP INDEX IF EXISTS "recents";
--------------------------------------------------------------- Demonstrates single-column indexes

-- Search for a movie with a unique entry and see the run time.
.timer on
SELECT * FROM "movies" WHERE "title" = 'Cars';
.timer off

-- Under the hood, when the query to find Cars was run, we triggered a scan of the table movies, that is,
-- the table movies was scanned top to bottom, one row at a time, to find all the rows with the title Cars.
-- We can optimize this query to be more efficient than a scan.
-- In the same way that textbooks often have an index, databases tables can have an index as well. 
-- An index, in database terminology, is a structure used to speed up the retrieval of rows from a table.

-- Creates index on titles column
.timer on
CREATE INDEX "title_index" ON "movies" ("title");
.timer off
-- After creating this index, we can run the previous query to find the movie titled Cars again and see the run time.

-- Show index as part of schema
.schema

-- Search again, via index
.timer on
SELECT * FROM "movies" WHERE "title" = 'Cars';
.timer off
-- The run time is significantly shorter.

-- Once the index was created, we just assumed that SQL would use it to find a movie. 
-- However, we can also explicitly see this using a SQLite command "EXPLAIN QUERY PLAN" before any query.
-- Other DBMSs might call this just simply "EXPLAIN", but in SQLite it's "EXPLAIN QUERY PLAN".
-- "EXPLAIN QUERY PLAN SQL" is used to obtain a high-level description of the strategy or plan 
-- that SQLite uses to implement a specific SQL query. 
-- Most significantly, EXPLAIN QUERY PLAN reports on the way in which the query uses database indices. 

-- Use EXPLAIN QUERY PLAN to show use of index
EXPLAIN QUERY PLAN
SELECT * FROM "movies" WHERE "title" = 'Cars';
-- The result shown in the terminal:
-- QUERY PLAN
-- `--SEARCH movies USING INDEX title_index (title=?)
-- The result shows SQLite will search the "movies" table using the index called "title_index" and a given value for "title". 
-- So we can actually see SQLite does plan to use the index to speed up this query. 

-- DROP INDEX
DROP INDEX "title_index";

-- After dropping the index, running EXPLAIN QUERY PLAN again with the SELECT query will demonstrate 
-- that the plan would revert to scanning the entire database "movies".
-- Show query plan without index
EXPLAIN QUERY PLAN
SELECT * FROM "movies" WHERE "title" = 'Cars';
-- The result in the terminal:
-- QUERY PLAN
-- `--SCAN movies
-- The result shows the plan is to scan "movies", 
-- which means going top to bottom through that "title" column and find me all the rows that have "Cars" in them.

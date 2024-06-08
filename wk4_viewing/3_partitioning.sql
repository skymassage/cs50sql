--------------------------------------------------------------- Open longlist.db
DROP VIEW IF EXISTS "longlist";
DROP VIEW IF EXISTS "average_book_ratings";
DROP VIEW IF EXISTS "2022";
--------------------------------------------------------------- Demonstrates views for partitioning data

-- Views can be used to partition data, or to break it into smaller pieces that will be useful to us or an application. 
-- Here our database stores all the longlisted books in a single table,
-- and we can have a different view of books for each year.

-- Queries for 2022 longlisted books
SELECT "id", "title" FROM "books" WHERE "year" = 2022;

-- Create view of 2022 longlisted books
CREATE VIEW "2022" AS
SELECT "id", "title" FROM "books" WHERE "year" = 2022;

-- Query for 2022 longlisted books from the "2022" table.
SELECT "id", "title" FROM "2022";
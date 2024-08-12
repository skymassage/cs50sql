------------------------------------------------------------------------------------ SELECT
-- Select all columns from "longlist" table
SELECT * FROM "longlist";

-- Select "title", "author", and "translator" column from "longlist" table
SELECT "title", "author", "translator" FROM "longlist";

-- If we mistype some of the query, SQL will give us what we asked for, but that column doesn't exist.
SELECT "titl" FROM "longlist";

------------------------------------------------------------------------------------ LIMIT
-- Limits results to first 3 rows
SELECT "title", "author" FROM "longlist" LIMIT 3;

-- Limits results to first 10 rows
SELECT "title", "author" FROM "longlist" LIMIT 10;

------------------------------------------------------------------------------------ WHERE
-- Select all books nominated in 2023
SELECT "title", "author" FROM "longlist" WHERE "year" = 2023;

-- Select all books by Fernanda Melchor
-- It is good practice to use double quotes ("") around table and column names, which are called SQL identifiers. 
-- And use single quotes ('') around strings to differentiate them from identifiers.
SELECT "title", "author" FROM "longlist" WHERE "author" = 'Fernanda Melchor';

-- Select all books not released in hardcover format:
-- Method 1: Use "!="
SELECT "title", "format" FROM "longlist" WHERE "format" != 'hardcover'; -- Note that 'hardcover' is a string
-- Method 2: Use "<>"
SELECT "title", "format" FROM "longlist" WHERE "format" <> 'hardcover';
-- Method 3: Use "NOT"
SELECT "title", "format" FROM "longlist" WHERE NOT "format" = 'hardcover';

-- Select the titles and authors of the books longlisted in 2022 or 2023
SELECT "title", "author" FROM "longlist" WHERE "year" = 2022 OR "year" = 2023;

-- Select the books longlisted in 2022 or 2023 that were not hardcovers
SELECT "title", "format" FROM "longlist" WHERE ("year" = 2022 OR "year" = 2023) AND "format" != 'hardcover';

------------------------------------------------------------------------------------ ORDER BY
-- Top 10 books by rating (incorrectly because the default is ascending order)
SELECT "title", "rating" FROM "longlist" ORDER BY "rating" LIMIT 10;

-- Top 10 books by rating (correctly because of the descending order using "ORDER BY ... DESC")
-- And "ASC" can be used to explicitly specify ascending order
SELECT "title", "rating" FROM "longlist" ORDER BY "rating" DESC LIMIT 10;

-- Ordering by more than one column
-- First order by rating, then order by the number of votes
SELECT "title", "rating", "votes" FROM "longlist" 
ORDER BY "rating" DESC, "votes" DESC
LIMIT 10;

-- Ordering with a condition
SELECT "title", "rating" FROM "longlist" 
WHERE "votes" > 10000 ORDER BY "rating" DESC 
LIMIT 10;

-- Sort books by title alphabetically
SELECT "title" FROM "longlist" ORDER BY "title";
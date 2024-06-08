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
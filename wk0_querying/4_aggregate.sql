-- Calculate the average rating of all longlisted books
SELECT AVG("rating") FROM "longlist";

-- Round the average rating to 2 decimal points
SELECT ROUND(AVG("rating"), 2) FROM "longlist";

-- Rename column with "AS"
SELECT ROUND(AVG("rating"), 2) AS "Average Rating" FROM "longlist";

-- Also rename table with "AS" and reference the column by the new table name
SELECT ROUND(AVG("l"."rating"), 2) AS "Average Rating" FROM "longlist" AS "l";

-- Select maximum rating
SELECT MAX("rating") FROM "longlist";

-- Select minimum rating
SELECT MIN("rating") FROM "longlist";

-- Using MAX and MIN for strings is based on alphabetical order
-- So here using MAX with the title column would give us the "largest" title alphabetically (i.e. the last one in the title column).
-- Similarly, MIN will give the first title alphabetically.
SELECT MAX("title"), MIN("title") FROM "longlist";

-- Calculate the total number of votes
SELECT SUM("votes") FROM "longlist";

-- Count the total number (rows) of books
SELECT COUNT(*) FROM "longlist";

-- Count the total number (rows) of translators (COUNT only returns those rows or those values that aren't null)
SELECT COUNT("translator") FROM "longlist";

-- Incorrectly count publishers (because some books have the same publisher)
SELECT COUNT("publisher") FROM "longlist";
-- Correctly count publishers with "DISTINCT" which ensures that only distinct values
SELECT COUNT(DISTINCT "publisher") FROM "longlist";
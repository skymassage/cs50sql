-- Demonstrate joining tables with JOIN using sea_lions.db

-- Shows all sea lions for which we have data
SELECT * FROM "sea_lions" JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- If there are any IDs in one table not present in the other, this row will not be present in the joined table. 
-- This kind of join is called an INNER JOIN.

-- Some other ways of joining tables that allow us to retain certain unmatched IDs are LEFT JOIN, RIGHT JOIN and FULL JOIN. 
-- Each of these is a kind of OUTER JOIN.

-- Show all sea lions, whether or not we have data
-- Use "LEFT JOIN" to keep all values of the left table ("sea_lions") even "sea_lions"."id" fully don't match "migrations"."id".
SELECT * FROM "sea_lions" LEFT JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";

-- Show all data, whether or not there are matching sea lions
-- Use "RIGHT JOIN" to keep all values of the right table ("migrations") even "sea_lions"."id" don't fully match "migrations"."id".
SELECT * FROM "sea_lions" RIGHT JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";
-- If SQL doesn't support "LEFT JOIN", we can use "LEFT JOIN" to replace it:
SELECT * FROM "migrations" LEFT JOIN "sea_lions" ON "migrations"."id" = "sea_lions"."id";

-- Show all data and all sea lions
-- Use "FULL JOIN" to keep all values of the both tables ("migrations" and "sea_lions") even "migrations"."id" don't fully match "sea_lions"."id".
SELECT * FROM "sea_lions" FULL JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";
-- If SQL doesn't support "FULL JOIN", we can use "LEFT JOIN" and "UNION" to replace it, like this:
SELECT "sea_lions".*, "migrations".* FROM "sea_lions" LEFT JOIN "migrations" ON "migrations"."id" = "sea_lions"."id"
UNION
SELECT "sea_lions".*, "migrations".* FROM "migrations" LEFT JOIN "sea_lions" ON "migrations"."id" = "sea_lions"."id";

-- JOIN "sea_lions" and "migrations" without specifying matching column
-- Since the value on which we are joining "sea_lions" and "migrations" has the same id column name in both tables, 
-- we can actually omit the "ON" section of the query using "NATURAL JOIN".
SELECT * FROM "sea_lions" NATURAL JOIN "migrations";

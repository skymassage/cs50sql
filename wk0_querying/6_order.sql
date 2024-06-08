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
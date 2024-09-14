-- Demonstrates aggregation by groups with GROUP BY using longlist.db
-- Note that "HAVING" should be used with "GROUP BY" and after "GROUP BY", and "WHERE" must be before "GROUP BY".

-- Find average rating for each book
SELECT "book_id", ROUND(AVG("rating"), 2) AS "average rating" FROM "ratings"
GROUP BY "book_id";
-- Here "GROUP BY" is used to create groups for each book and then collapse the ratings of the group into an average rating.

-- Find the number of ratings given to each book
SELECT "book_id", COUNT("rating") FROM "ratings" GROUP BY "book_id";

-- Join titles
SELECT "title", ROUND(AVG("rating"), 2) AS "average rating" FROM "ratings"
JOIN "books" ON "books"."id" = "ratings"."book_id"
GROUP BY "book_id";

-- Find books with a higher rating than 4.0 using "HAVING"
-- "HAVING" allows for additional constraints based on the number of results. 
-- "HAVING" should be used with "GROUP BY" and after "GROUP BY", and "WHERE" must be before "GROUP BY"..
SELECT "title", ROUND(AVG("rating"), 2) AS "average rating" FROM "ratings"
JOIN "books" ON "books"."id" = "ratings"."book_id"
GROUP BY "book_id"
HAVING "average rating" > 4.0;
-- "HAVING" is used here to specify a condition for the groups, 
-- instead of WHERE (which can only be used to specify conditions for individual rows, not grouped rows).

-- Find books with a higher rating than 4.0 using "HAVING", and order in descending order.
SELECT "title", ROUND(AVG("rating"), 2) AS "average rating" FROM "ratings"
JOIN "books" ON "books"."id" = "ratings"."book_id"
GROUP BY "book_id"
HAVING "average rating" > 4.0
ORDER BY "average rating" DESC;
-- Note that we can't find books books with a higher rating than 4.0 first and then order them,
-- i.e., we cannot use "ORDER BY" before "GROUP BY".
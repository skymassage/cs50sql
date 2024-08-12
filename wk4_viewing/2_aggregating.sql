--------------------------------------------------------------- Open longlist.db
DROP VIEW IF EXISTS "longlist";
DROP VIEW IF EXISTS "average_book_ratings";
DROP VIEW IF EXISTS "2022";
--------------------------------------------------------------- Demonstrates views for aggregating data

-- Return book_id, title, year and rounded average rating columns
SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";

-- Define book IDs, rounded ratings, title, and year columns as a view
CREATE VIEW "average_book_ratings" AS
SELECT "book_id" AS "id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
JOIN "books" ON "ratings"."book_id" = "books"."id"
GROUP BY "book_id";
-- Note that the rating column here has already contained the average ratings per book. 

-- Find average book ratings by year nominated.
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" GROUP BY "year";
-- We only need to group these by year and calculate the average rating per year again, 
-- because the rating column in "average_book_ratings" has already contained the average ratings per book.

-- One more advantage of views is that we can requery the view to see the update if the table refernced by the view has update.
-- Here, if we were to add in some new rating for a book to our "ratings" table (like using some INSERT INTO statement),
-- we could just requery this view to find the updated average rating per book:
SELECT * FROM "average_book_ratings";
-- Every time I query this view, we'll rerun essentially that query from before. 
-- And We'll see the updated averages for each book.
-- Views couldn't be updated, because a view doesn't have any data inside of itstelf like tables. 
-- Views actually pull data from the underlying tables each time they are queried.
-- This means that when an underlying table is updated, the next time the view is queried, it will display updated data from the table.

-- Use "CREATE TEMPORARY VIEW" to create temporary views that are not stored in the database schema.
-- This command creates a view that exists only for the duration of our connection with the database.
-- In general, temporary views are used when we want to organize data in some way without actually storing that organization long-term.

-- Create temporary view of average ratings by year
CREATE TEMPORARY VIEW "average_ratings_by_year" AS
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings" 
GROUP BY "year";
-- We can leave SQLite and enter again to check if the temporary view "average_ratings_by_year" exixts in the database.

---------------------------------------------------------------

-- A regular view exists forever in our database schema,
-- And a temporary view exists for the duration of our connection with the database. 
-- Common table expression (CTE) is a view that only exists for a single query alone.

-- First, we need to drop the existing view "average_book_ratings" so that we can reuse the name "average_book_ratings".
DROP VIEW "average_book_ratings";
-- Create a CTE containing the average ratings per book. 
-- Then use the average ratings per book to calculate the average ratings per year, in much the same way as we did before.
-- Show that CTEs are views accessible for the duration of a query
WITH "average_book_ratings" AS (
  SELECT "book_id", "title", "year", ROUND(AVG("rating"), 2) AS "rating" FROM "ratings"
  JOIN "books" ON "ratings"."book_id" = "books"."id"
  GROUP BY "book_id"
)
SELECT "year", ROUND(AVG("rating"), 2) AS "rating" FROM "average_book_ratings"
GROUP BY "year";
-- The CTE "average_book_ratings" doesn't exixt in the database anymore.
.schema
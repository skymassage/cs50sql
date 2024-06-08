--------------------------------------------------------------- Open longlist.db
DROP VIEW IF EXISTS "longlist";
DROP VIEW IF EXISTS "average_book_ratings";
DROP VIEW IF EXISTS "2022";
--------------------------------------------------------------- Demonstrates views for simplifying data access

-- A view is a virtual table defined by a query.

-- Find books written by Fernanda Melchor
SELECT "title" FROM "books" WHERE "id" IN (
    SELECT "book_id" FROM "authored" WHERE "author_id" = (
        SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'
    )
);

-- Join authors with their book titles
SELECT "name", "title" FROM "authors"
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "books"."id" = "authored"."book_id";

-- Create a view to save the virtual table created in the previous query .
-- And the view created here is called "longlist".
CREATE VIEW "longlist" AS
SELECT "name", "title" FROM "authors"
JOIN "authored" ON "authors"."id" = "authored"."author_id"
JOIN "books" ON "books"."id" = "authored"."book_id";
-- We can ".schema" to check if the view "longlist" exixts in the database schema.

-- Returns all rows from view
SELECT * FROM "longlist";

-- Using this view, we can considerably simplify the query needed to find the books written by Fernanda Melchor.
SELECT "title" FROM "longlist" WHERE "name" = 'Fernanda Melchor';

-- Display the data within the longlist view, ordered by the book titles.
SELECT "name", "title" FROM  "longlist" ORDER BY "title";
-- We can also have the view itself be ordered.
-- We can do this by including an ORDER BY clause when creating the view, so we don't need to order the view.

-- Drop the view "longlist"
DROP VIEW "longlist";

-- A view, being a virtual table, does not consume much more disk space to create. 
-- The data within a view is still stored in the underlying tables, but still accessible through this simplified view.
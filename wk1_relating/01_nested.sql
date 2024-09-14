-- Demonstrates subqueries using longlist.db

-- Finds all books published by MacLehose Press, with hard-coded id
SELECT "id" FROM "publishers" WHERE "publisher" = 'MacLehose Press'; -- id = 12

SELECT "title" FROM "books" WHERE "publisher_id" = 12;

-- Finds all books published by MacLehose Press, with a nested query
SELECT "title" FROM "books" WHERE "publisher_id" = (
    SELECT "id" FROM "publishers" WHERE "publisher" = 'MacLehose Press'
);

-- Finds all ratings for "In Memory of Memory"
SELECT "rating" FROM "ratings" WHERE "book_id" = (
    SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory'
);

-- Finds average rating for "In Memory of Memory"
SELECT AVG("rating") FROM "ratings" WHERE "book_id" = (
    SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory'
);

-- Finds author who wrote "The Birthday Party"
SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party';

SELECT "author_id" FROM "authored" WHERE "book_id" = (
    SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party'
);

SELECT "name" FROM "authors" WHERE "id" = (
    SELECT "author_id" FROM "authored" WHERE "book_id" = (
        SELECT "id" FROM "books" WHERE "title" = 'The Birthday Party'
    )
);

-- Finds all books by Fernanda Melchor, using IN
SELECT "title" FROM "books" WHERE "id" IN (
    SELECT "book_id" FROM "authored" WHERE "author_id" = (
        SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'   -- id = 24
    )    -- book_id = [14, 48]
);   -- title = [Paradais, Hurricane Season]

-- Uses IN to search for multiple authors
SELECT "title" FROM "books" WHERE "id" IN (
    SELECT "book_id" FROM "authored" WHERE "author_id" IN (
        SELECT "id" FROM "authors" WHERE "name" IN ('Fernanda Melchor', 'Annie Ernaux')   -- id = [7, 24]
    )   -- book_id = [14, 48, 65]
);   -- title = [Paradais, Hurricane Season, The Years]

-- For WHERE syntax, use "IN" to query more than one value in the column, that is:
-- WHERE "<column_name>" = <value>;
-- WHERE "<column_name>" IN (<value_1>, <value_2>, ...);
-- Demonstrates set operations using longlist.db

-- UNION
-- Selects all authors, labeling as authors
SELECT 'author' AS "profession", "name" FROM "authors";
-- Actually, we don't have the "author" column in the "authors" table.
-- If the column name we specify doesn't exist, it will create a new column whose all values and title are that column we specify.
-- So here we creat the additional "author" column whose values are all 'auther', but we rename its column title as "profession" using "AS".

-- Selects all translators, labeling as translators
SELECT 'translator' AS "profession", "name" FROM "translators";

-- Combines authors and translators into one result set
SELECT 'author' AS "profession", "name" FROM "authors"
UNION
SELECT 'translator' AS "profession", "name" FROM "translators";

-- INTERSECT (Assume names are unique)
-- Finds authors and translators
SELECT "name" FROM "authors"
INTERSECT
SELECT "name" FROM "translators";

-- Finds intersection of books translated by Sophie Hughes and Margaret Jull Costa
SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE name = 'Sophie Hughes'
)
INTERSECT
SELECT "book_id" FROM "translated" WHERE "translator_id" = (
    SELECT "id" FROM "translators" WHERE name = 'Margaret Jull Costa'
);

-- Finds intersection of books
SELECT "title" FROM "books" WHERE "id" IN (
    SELECT "book_id" FROM "translated" WHERE "translator_id" = (
        SELECT "id" FROM "translators" WHERE name = 'Sophie Hughes'
    )
    INTERSECT
    SELECT "book_id" FROM "translated" WHERE "translator_id" = (
        SELECT "id" FROM "translators" WHERE name = 'Margaret Jull Costa'
    )
);

-- EXCEPT (Assume names are unique)
-- Finds translators who are not authors
SELECT "name" FROM "translators"
EXCEPT
SELECT "name" FROM "authors";
-- Finds authors who are not translators
SELECT "name" FROM "authors"
EXCEPT
SELECT "name" FROM "translators";

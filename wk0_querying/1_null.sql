-- NULL is a type used to indicate that certain data doesn't have a value, or doesn't exist in the table.
-- For example, the books in our database have a translator along with an author.
-- However, only some of the books have been translated to English.
-- For other books, the translator value will be NULL.

-- Find books without a translator
SELECT "title", "translator" FROM "longlist" WHERE "translator" IS NULL; -- Note that use "IS" not '='

-- Find books with a translator
SELECT "title", "translator" FROM "longlist" WHERE "translator" IS NOT NULL;
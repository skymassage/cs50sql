-- Select all columns from "longlist" table
SELECT * FROM "longlist";

-- Select "title" column from "longlist" table
SELECT "title" FROM "longlist";

-- Select "title", "author", and "translator" column from "longlist" table
SELECT "title", "author", "translator" FROM "longlist";

-- If we mistype some of the query, SQL will give us what we asked for, but that column doesn't exist.
SELECT "titl" FROM "longlist";

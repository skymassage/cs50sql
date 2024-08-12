--------------------------------------------------------------- Create or open mfa.db and create the table
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";
DROP TRIGGER IF EXISTS "sell";
DROP TRIGGER IF EXISTS "buy";

CREATE TABLE IF NOT EXISTS "collections"(
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES 
('Farmers working at dawn', '11.6152', '1911-08-03'),
('Imaginative landscape', '56.496', NULL),
('Profusion of flowers', '56.257', '1956-04-12'),
('Spring outing', '14.76', '1914-01-08');

CREATE TABLE IF NOT EXISTS "artists"(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

INSERT INTO "artists" ("name") 
VALUES 
('Li Yin'),
('Qian Weicheng'),
('Unidentified artist'),
('Zhou Chen');

CREATE TABLE IF NOT EXISTS "created"(
    "artist_id" INTEGER,
    "collection_id" INTEGER,
    PRIMARY KEY("artist_id", "collection_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE,
    FOREIGN KEY("collection_id") REFERENCES "collections"("id") ON DELETE CASCADE
);

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
((SELECT "id" FROM "artists" WHERE "name" = 'Li Yin'), (SELECT "id" FROM "collections" WHERE "title" = 'Imaginative landscape')),
((SELECT "id" FROM "artists" WHERE "name" = 'Qian Weicheng'), (SELECT "id" FROM "collections" WHERE "title" = 'Profusion of flowers')),
((SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'), (SELECT "id" FROM "collections" WHERE "title" = 'Farmers working at dawn')),
((SELECT "id" FROM "artists" WHERE "name" = 'Zhou Chen'), (SELECT "id" FROM "collections" WHERE "title" = 'Spring outing'));
---------------------------------------------------------------

-- A trigger is a SQL statement to run in response to some other SQL statement like an insert, an update, or a delete.
-- Here we have a "transactions" table which can automatically insert a new row to track each buying and selling of an item,
-- based on each insertion or deletion of an item in the "collections" table.
-- Creates a table to track buying and selling of items from collections.
CREATE TABLE IF NOT EXISTS "transactions" (
    "id" INTEGER,
    "title" TEXT, "action" TEXT, 
    PRIMARY KEY("id")
);

-- Demonstrates triggers on delete and insert

-- First create trigger, and then some name.
-- we tend to give triggers names to identify them among all of our database schema.
-- After creating trigger, we have to specify the trigger to run before or after some other SQL statement using "BEFORE" or "AFTER".
-- The SQL statements after "AFTER" or "BEFORE" would be insert, delete, update, like: INSERT ON <table>
--                                                                                     DELETE ON <table>
--                                                                                     UPDATE OF <column> ON <table>
-- Then, we can use "FOR EACH ROW" which means if we were to maybe insert (delete or update) multiple rows, 
-- we should run our SQL statement for each row that we insert (delete or update). 
-- For instance, if we delete two rows, we should run our statement two times. 
-- Finally, we can use "BEGIN" and "END" to contain our SQL statement whenever we hear a insert (delete or update) on the table. 
-- For example, a trigger could be like this:
CREATE TRIGGER <name>
BEFORE DELETE ON <table>
FOR EACH ROW
BEGIN
 <our_SQL_statement_1>;
 <our_SQL_statement_2>;
 ...
END;
-- This example means listening for a delete and run our statement in here for each row that we delete.
-- And we can also remove a trigger like this:
DROP TRIGGER <trigger>;

-- Creates a trigger to log selling items from collections
CREATE TRIGGER "sell" 
BEFORE DELETE ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action") VALUES (OLD."title", 'sold');
END;
-- In triggers, we can get access to the keyword called "OLD" meaning the old row that we've just deleted from "collections". 

-- Lists existing triggers
.schema

-- Deletes from collections
DELETE FROM "collections" WHERE "title" = 'Profusion of flowers';

-- Creates a trigger to log buying items
CREATE TRIGGER "buy" 
AFTER INSERT ON "collections"
FOR EACH ROW
BEGIN
    INSERT INTO "transactions" ("title", "action") VALUES (NEW."title", 'bought');
END;
-- In addition to "OLD", we also have "NEW" meaning the new row that we're going to insert.

-- Adds item to collections
INSERT INTO "collections" ("title", "accession_number", "acquired") VALUES ('Profusion of flowers', '56.257', '1956-04-12');
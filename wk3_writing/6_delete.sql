--------------------------------------------------------------- Create or open mfa.db and create the table
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";

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
--------------------------------------------------------------- 

-- We can specify the action to be taken when an ID referenced by a foreign key is deleted. 
-- To do this, when we are creating tables, we can use the keyword ON DELETE followed by the action to be taken.
-- ON DELETE RESTRICT: Restricts us from deleting IDs when the foreign key constraint is violated.
-- ON DELETE NO ACTION: Allows the deletion of IDs that are referenced by a foreign key and nothing happens.
-- ON DELETE SET NULL: Allows the deletion of IDs that are referenced by a foreign key and sets the foreign key references to NULL.
-- ON DELETE SET DEFAULT: Does the same as the previous, but allows us to set a default value instead of NULL.
-- ON DELETE CASCADE: Allows the deletion of IDs that are referenced by a foreign key 
--                    and also proceeds to cascadingly delete the referencing foreign key rows. 
--                    For example, if we used this to delete an artist ID, 
--                    all the artist's affiliations with the artwork would also be deleted from the created table.

-- By default, SQLite will select the largest ID present in the table and increment it to obtain the next ID. 
-- But we can use the "AUTOINCREMENT" keyword for primary keys while creating a column to indicate 
-- that any deleted ID should be repurposed for a new row being inserted into the table.

-- Adds ON DELETE action
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

-- Demonstrates deleting rows with ON DELETE actions

-- Deletes an artist when foreign key ON DELETE action is set to CASCADE
DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- It will not result in an error, and will cascade the deletion from the "artists" table to the "created" table.
-- Note that we should use the following SQLite command to make sure the foreign key also to be deleted successfully:
PRAGMA foreign_keys = ON;
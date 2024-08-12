--------------------------------------------------------------- Create or open mfa.db and create the tables
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

CREATE TABLE IF NOT EXISTS "artists" (
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

CREATE TABLE IF NOT EXISTS "created" (
    "artist_id" INTEGER,
    "collection_id" INTEGER,
    PRIMARY KEY("artist_id", "collection_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id"),
    FOREIGN KEY("collection_id") REFERENCES "collections"("id")
);

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
((SELECT "id" FROM "artists" WHERE "name" = 'Li Yin'), (SELECT "id" FROM "collections" WHERE "title" = 'Imaginative landscape')),
((SELECT "id" FROM "artists" WHERE "name" = 'Qian Weicheng'), (SELECT "id" FROM "collections" WHERE "title" = 'Profusion of flowers')),
((SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'), (SELECT "id" FROM "collections" WHERE "title" = 'Farmers working at dawn')),
((SELECT "id" FROM "artists" WHERE "name" = 'Zhou Chen'), (SELECT "id" FROM "collections" WHERE "title" = 'Spring outing'));
--------------------------------------------------------------- 

-- There might be cases where deleting some data could impact the integrity of a database.
-- Foreign key constraints are a good example. A foreign key column references the primary key of a different table. 
-- If we were to delete the primary key, the foreign key column would have nothing to reference. 
-- So it will raise an error. However, in some environment, it won't raise any error to remind.

-- Demonstrates deleting rows with constraints

-- Raise a foreign key constraint error (it may not raise any error in this environment)
DELETE FROM "artists" WHERE "name" = 'Unidentified artist';

-- We need to delete the corresponding rows from the "created" table before deleting from the "artists" table.
-- First, delete the "artist"'s affiliation with their work.
DELETE FROM "created" WHERE "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'
);
-- Then, delete the artist themselves.
DELETE FROM "artists" WHERE "name" = 'Unidentified artist';
-- The previous query effectively deletes the artist's affiliation with their work. 
-- Once the affiliation no longer exists, we can use the second query to delete the artist's data without violating the foreign key constraint.
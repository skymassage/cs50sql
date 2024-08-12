--------------------------------------------------------------- Create or open mfa.db and create the table
DROP TABLE IF EXISTS "collections";
DROP TABLE IF EXISTS "another_collections";
DROP TABLE IF EXISTS "artists";
DROP TABLE IF EXISTS "created";
DROP TABLE IF EXISTS "transactions";
DROP TABLE IF EXISTS "votes";

CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

CREATE TABLE "another_collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);

INSERT INTO "another_collections" ("title", "accession_number", "acquired")
VALUES 
('Tile Lunette', '06.2437', '1906-11-08'),
('Statuette of a shrew', '01.105', '1901-02-11');
---------------------------------------------------------------

-- Demonstrates adding individual rows to a table

-- Add a new item to the collections
INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (1, 'Profusion of flowers', '56.257', '1956-04-12');

-- Add a new item to the collections
-- A primary key can be assigned any value that matches its affinity and is not repeated.
INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (5, 'Farmers working at dawn', '11.6152', '1911-08-03');

-- Demonstrating primary key auto-increments:
-- Add a new item to the collections without assigning a value to the "id" column.
-- And the value of the primary key will increment from the highest value by default, so the "id" here will be 6.
INSERT INTO "collections" ("title", "accession_number", "acquired") VALUES ('Spring outing', '14.76', '1914-01-08');

-- Show violation of UNIQUE, it will be an error.
INSERT INTO "collections" ("title", "accession_number", "acquired") VALUES ('Spring outing', '14.76', '1914-01-08');

-- Show violation of NOT NULL, it will be an error.
INSERT INTO "collections" ("title", "accession_number", "acquired") VALUES (NULL, '56.496', '1914-01-08');

-- Demonstrates adding multiple rows to a table (the "acquired" column doesn't have the NULL constraint)
INSERT INTO "collections" ("title", "accession_number", "acquired") 
VALUES
('Imaginative landscape', '56.496', NULL),
('Peonies and butterfly', '06.1899', '1906-01-01');

-- We can also use subquery in the VALUES part.
INSERT INTO "collections" ("title", "accession_number", "acquired") 
VALUES
('Statuette of a shrew', (SELECT "accession_number", "acquired" FROM "another_collections" WHERE "title" = 'Statuette of a shrew'))

-- Omit the "VALUES" keyword when we use subquery for insertion across all columns.
INSERT INTO "collections" ("title", "accession_number", "acquired") 
SELECT "title", "accession_number", "acquired" FROM "another_collections" WHERE "title" = 'Tile Lunette';
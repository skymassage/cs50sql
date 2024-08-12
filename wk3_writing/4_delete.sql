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
('Profusion of flowers', '56.257', '1956-04-12'),
('Farmers working at dawn', '11.6152', '1911-08-03'),
('Spring outing', '14.76', '1914-01-08'),
('Imaginative landscape', '56.496', NULL),
('Peonies and butterfly', '06.1899', '1906-01-01'),
('Tile Lunette', '06.2437', '1906-11-08'),
('Statuette of a shrew', '01.105', '1901-02-11');
---------------------------------------------------------------

-- Demonstrates deleting rows from a single table.

-- Delete items with particular title
DELETE FROM "collections" WHERE "title" = 'Spring outing';

-- Delete items where value is NULL
DELETE FROM "collections" WHERE "acquired" IS NULL;

-- Delete items acquired before the museum moved to a new location in 1909
DELETE FROM "collections" WHERE "acquired" < '1909-01-01';

-- Delete all rows in the table without the "WHRER" statement
DELETE FROM "collections";
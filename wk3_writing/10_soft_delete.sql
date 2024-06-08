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
--------------------------------------------------------------- 

-- Hard Delete: Hard delete, on the other hand, is the traditional approach where data is permanently removed from the database. Once a record is hard-deleted, it cannot be recovered unless there are backups.
-- Soft Delete: Soft delete is a technique where instead of permanently removing a record from a database, 
--              you mark it as "deleted" by setting a flag or status. 
--              This means the data remains in the database but is considered inactive. 
--              Soft deletes are often reversible, making it easier to recover data if needed.

-- Here we have collections, but we also add a new column called "deleted," and by default, the value here will be 0. 
-- That is, by default, we'll add some artwork to my collections table and deleted will be 0. 
-- Instead of deleting it fully from our table or removing the row, we could mark it as deleted. 
-- We could change the deleted column from a 0 to a 1.

-- Demonstrate soft deletes

-- Add a "deleted" column to "collections" table
ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;

-- View updated schema of collections table
.schema "collections"

-- View data
SELECT * FROM "collections";

-- Instead of deleting an item, update its deleted column to be 1
UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';

-- Select all items from collections that are not deleted
SELECT * FROM "collections" WHERE "deleted" != 1;

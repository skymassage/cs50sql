-------------------------------------------------------------------------------------- Open mfa.db
DROP TABLE IF EXISTS "collections";
DROP VIEW IF EXISTS "current_collections";
DROP TRIGGER IF EXISTS "delete";
DROP TRIGGER IF EXISTS "insert_when_exists";
DROP TRIGGER IF EXISTS "insert_when_new";

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
-------------------------------------------------------------------------------------- Demonstrate soft deletes

-- View data in "collections" table
SELECT * FROM "collections";

-- View schema of collections table
.schema collections

-- Add a "deleted" column to "collections" table
ALTER TABLE "collections" ADD COLUMN "deleted" INTEGER DEFAULT 0;

-- View updated data in "collections table"
SELECT * FROM "collections";

-- View updated schema of collections table
.schema collections

-- Instead of deleting an item, updates its deleted column to be 1
UPDATE "collections" SET "deleted" = 1 WHERE "title" = 'Farmers working at dawn';

-- Selects all items from collections that are not deleted
SELECT * FROM "collections" WHERE "deleted" = 0;

-- Create a view to show only items in collections that are NOT deleted
CREATE VIEW "current_collections" AS
SELECT "id", "title", "accession_number", "acquired" FROM "collections" WHERE "deleted" = 0;

-- Select from "current_collections" view to see non-deleted items
SELECT * FROM "current_collections";

-- Fail to delete an item from the view
DELETE FROM "current_collections" WHERE "title" = 'Imaginative landscape';

--------------------------------------------------------------------------------------

-- We already know that it is not possible to insert data into or delete data from a view. 
-- However, we can set up a trigger that inserts into or deletes from the underlying table. 
-- The "INSTEAD OF" trigger allows us to do this.
-- An INSTEAD OF trigger allows us to skip an INSERT, DELETE, or UPDATE statement to a table or a view 
-- and execute other statements defined in the trigger instead. 
-- The actual insert, delete, or update operation doesn't occur at all.

-- Create trigger to delete items from a view
CREATE TRIGGER "delete"
INSTEAD OF DELETE ON "current_collections"
FOR EACH ROW
BEGIN
    UPDATE "collections" SET "deleted" = 1 WHERE "id" = OLD."id";
END;
-- Every time we try to delete rows from the view, this trigger will update the deleted column of the row 
-- in the underlying table "collections", thus completing the soft deletion.
-- Thus, deletion won't happen when we try to delete rows from the view "current_collections", so it won't raise any error.
-- We use the keyword "OLD" within our update clause to indicate that the ID of the row updated in "collections" 
-- should be the same as the ID of the row we are trying to delete from "current_collections".

-- Now, we can delete a row from the current_collections view without rasing an error.
DELETE FROM "current_collections" WHERE "title" = 'Imaginative landscape';
-- We can verify that this worked by querying the view.
SELECT * FROM "current_collections";
-- And check the "deleted" value of the item has been changed to 1.
SELECT * FROM "collections";

-- Similarly, we can create a trigger that inserts data into the underlying table when we try to insert it into a view.
-- There are two situations to consider here:
-- 1. Insert into a view a row that already exists in the underlying table, but was soft deleted.
-- 2. Insert a row that does not exist in the underlying table. 

-- Situation 1: Create trigger to revert an item's deletion
CREATE TRIGGER "insert_when_exists"
INSTEAD OF INSERT ON "current_collections"
FOR EACH ROW WHEN NEW."accession_number" IN (SELECT "accession_number" FROM "collections")
BEGIN
    UPDATE "collections" SET "deleted" = 0 WHERE "accession_number" = NEW."accession_number";
END;
-- The "WHEN" keyword is used to check if the "accession" number of the artwork already exists in the "collections" table. 

-- Insert the soft deleted item back the "current_collections" view
INSERT INTO "current_collections" ("title", "accession_number", "acquired")
VALUEs ('Imaginative landscape', '56.496', NULL);
-- Verify that soft deleted item has been reversed in the view.
SELECT * FROM "current_collections";
-- And check the "deleted" value of the item has been inverted to 0.
SELECT * FROM "collections";

-- Situation 2: Create trigger to insert a new item into collections
CREATE TRIGGER "insert_when_new"
INSTEAD OF INSERT ON "current_collections"
FOR EACH ROW WHEN NEW."accession_number" NOT IN (SELECT "accession_number" FROM "collections")
BEGIN
    INSERT INTO "collections" ("title", "accession_number", "acquired")
    VALUES (NEW."title", NEW."accession_number", NEW."acquired");
END;

-- Insert a new item back the "current_collections" view
INSERT INTO "current_collections" ("title", "accession_number", "acquired")
VALUEs ('Statuette of a shrew', '01.105', '1901-02-11');
-- Verify the new item has been added in the view.
SELECT * FROM "current_collections";
-- And check the new item has been inserted into "collections".
SELECT * FROM "collections";
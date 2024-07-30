-- Uses mbta.db

-- Demonstrates renaming a table
ALTER TABLE "visits" RENAME TO "swipes";   -- Renames "vists" table to "swipes"

-- Demonstrates adding a column to a table
ALTER TABLE "swipes" ADD COLUMN "ttpe" TEXT;   -- Adds "ttpe" column to "swipes" table (intentional typo)

-- Demonstrates renaming a column
ALTER TABLE "swipes" RENAME COLUMN "ttpe" TO "type";   -- Fixes typo using RENAME COLUMN
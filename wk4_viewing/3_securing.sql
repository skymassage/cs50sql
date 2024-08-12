--------------------------------------------------------------- Open rideshare.db
DROP TABLE IF EXISTS "rides";
DROP VIEW IF EXISTS "analysis";

CREATE TABLE "rides" (
    "id" INTEGER,
    "origin" TEXT NOT NULL,
    "destination" INTEGER NOT NULL,
    "rider" TEXT NOT NULL,
    PRIMARY KEY("id")
);

INSERT INTO "rides" ("origin", "destination", "rider")
VALUES
('Good Egg Galaxy', 'Honeyhive Galaxy', 'Peach'),
('Castle Courtyard', 'Cascade Kingdom', 'Mario'),
('Metro Kingdom', 'Mushroom Kingdom', 'Luigi'),
('Seaside Kingdom', 'Deep Woods', 'Bowser');
--------------------------------------------------------------- Demonstrate views for securing data.

-- Reveal all rides information.
SELECT * FROM "rides";

-- Reveal only subset of columns.
SELECT "id", "origin", "destination" FROM "rides";

-- Make clear that rider is anonymous. 
-- Add a new column that's filled with a string "anonymous", and rename this column as rider.
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";
-- So the all values the "rider" colunm are 'Anonymous'.

-- Create a view that all riders are anonymous for analysts.
CREATE VIEW "analysis" AS
SELECT "id", "origin", "destination", 'Anonymous' AS "rider" FROM "rides";

-- Query the view.
SELECT "origin", "destination", "rider" FROM "analysis";

-- Although we can create a view that anonymizes data, 
-- analysts still could simply query the original "rides" table and see all the rider names 
-- which we tried to omit in the "analysis" view.
-- Because in SQLite we can't set access controls, which means having access to the entire database or no access at all.
-- In other DBMSes though, we could set access controls. We could give analysts to access only to the analysis view. 
-- And we can give ourselves to access to both the "rides" table and the "analysis" view.

-- (14, 98, 4), (114, 3, 5), (618, 72, 9), (630, 7,3), (932, 12, 5), (2230, 50, 7), (2346, 44, 10), (3041, 14, 5)
-- For each set (sentence_id, start_id, len) above, first select the sentence based on its "sentence_id" in the database,
-- and then start from the "start_char"-th character in the sentence and take out "len" charaters.
-- Finally, piece these sets together into a message.

-- The schema of this database:
-- CREATE TABLE IF NOT EXISTS "sentences" (
--     "id" INTEGER,
--     "sentence" TEXT NOT NULL,
--     PRIMARY KEY("id")
-- );

------------------------------------------------------------------------------------------------- Clean the table and view

DROP TABLE IF EXISTS "temp";
DROP VIEW IF EXISTS "message";

------------------------------------------------------------------------------------------------- Method 1:

CREATE TABLE "temp" (
    "sentence_id" INTEGER,
    "start_char" INTEGER NOT NULL,
    "len" INTEGER NOT NULL,
    PRIMARY KEY("sentence_id")
);

INSERT INTO "temp" ("sentence_id", "start_char", "len")
VALUES
(14, 98, 4), (114, 3, 5), (618, 72, 9), (630, 7,3), (932, 12, 5), (2230, 50, 7), (2346, 44, 10), (3041, 14, 5);

CREATE VIEW "message" AS
SELECT substr("sentence", "start_char", "len") AS "phrase" FROM "sentences"
JOIN "temp" ON "temp"."sentence_id" = "sentences"."id";
-- substr(<string>, <start>, <length>):
--   <string> is a string from which a substring is to be returned.
--   <start> is an integer indicating a string position within the string X.
--   <length> is an integer indicating a number of characters to be returned.

------------------------------------------------------------------------------------------------- Method 2:

CREATE TABLE "temp"(
    "phrase" text
);

INSERT INTO "temp" ("phrase") SELECT substr("sentence", 98, 4) AS "phrase" FROM "sentences" WHERE "id" = 14;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 3, 5) AS "phrase" FROM "sentences" WHERE "id" = 114;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 72, 9) AS "phrase" FROM "sentences" WHERE "id" = 618;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 7, 3) AS "phrase" FROM "sentences" WHERE "id" = 630;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 12, 5) AS "phrase" FROM "sentences" WHERE "id" = 932;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 50, 7) AS "phrase" FROM "sentences" WHERE "id" = 2230;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 44, 10) AS "phrase" FROM "sentences" WHERE "id" = 2346;
INSERT INTO "temp" ("phrase") SELECT substr("sentence", 14, 5) AS "phrase" FROM "sentences" WHERE "id" = 3041;

CREATE VIEW message AS
SELECT * FROM "temp";

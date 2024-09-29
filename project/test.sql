----------------------------------------------------------------- 
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "items";
DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "order_details";
DROP TABLE IF EXISTS "comments";
DROP TABLE IF EXISTS "ratings";
DROP TABLE IF EXISTS "watchlists";

DROP VIEW IF EXISTS "current_items";

DROP TRIGGER IF EXISTS "add_item";
DROP TRIGGER IF EXISTS "update_item";
DROP TRIGGER IF EXISTS "delete_item";

DROP INDEX IF EXISTS "customer_index";
DROP INDEX IF EXISTS "rating_index";
DROP INDEX IF EXISTS "category_index";
DROP INDEX IF EXISTS "item_index";

----------------------------------------------------------------- Tables
-- Table for customers in the website
CREATE TABLE "customers" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "gender" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "city" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for items in the website
CREATE TABLE "items" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "category_id" INTEGER, 
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "number" INTEGER NOT NULL CHECK ("number" > 0),
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "avilable" INTEGER NOT NULL CHECK("avilable" IN (0, 1)),
    PRIMARY KEY("id"),
    FOREIGN KEY("category_id") REFERENCES "categories"("id")
);

-- Table for item categories 
CREATE TABLE "categories" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for orders
CREATE TABLE "orders" (
    "id" INTEGER,
    "customer_id" INTEGER,
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

-- Table for order details
CREATE TABLE "order_details" (
    "order_id" INTEGER ,
    "item_id" INTEGER,
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "number" INTEGER NOT NULL CHECK("number" > 0),
    PRIMARY KEY("order_id", "item_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Table for item comments
CREATE TABLE "comments" (
    "id" INTEGER,
    "item_id" INTEGER,
    "customer_id" INTEGER,
    "content" TEXT NOT NULL,
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Table for item ratings
CREATE TABLE "ratings" (
    "item_id" INTEGER,
    "customer_id" INTEGER,
    "rating" INTEGER CHECK("rating" in (1, 2, 3, 4, 5)),
    PRIMARY KEY("item_id", "customer_id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

-- Table for customers' watchlists
CREATE TABLE "watchlists" (
    "customer_id" INTEGER,
    "item_id" INTEGER,
    PRIMARY KEY("customer_id", "item_id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

----------------------------------------------------------------- Views
-- View for the current items
CREATE VIEW "current_items" AS
SELECT "items"."id" AS "item_id", "title", "categories"."name" AS "category", "price", "number", "creating_time" FROM "items"
JOIN "categories" ON "items"."category_id" = "categories"."id"
WHERE "avilable" = 1
ORDER BY "creating_time";

----------------------------------------------------------------- Triggers
-- Trigger for adding new items
CREATE TRIGGER "add_item"
INSTEAD OF INSERT ON "current_items"
FOR EACH ROW
BEGIN
    INSERT INTO "items" ("category_id", "title", "price", "number", "avilable")
    VALUES ((SELECT "id" FROM "categories" WHERE "name" = NEW."category"),
            NEW."title", NEW."price", NEW."number", 1
    );
END;

-- Trigger for updating the number of items
CREATE TRIGGER "update_item"
INSTEAD OF UPDATE OF "number" ON "current_items"
FOR EACH ROW
BEGIN
    UPDATE "items" SET "number" = NEW."number" WHERE "items"."id" = NEW."item_id";
END;

-- Trigger for soft deletion of sold items which are sold out
CREATE TRIGGER "delete_item"
INSTEAD OF DELETE ON "current_items"
FOR EACH ROW 
BEGIN
    UPDATE "items" SET "avilable" = 0 WHERE "id" = OLD."item_id";
END;

----------------------------------------------------------------- Indexes
CREATE INDEX "customer_index" ON "customers" ("gender", "age", "city");
CREATE INDEX "item_index" ON "items" ("price", "number", "creating_time", "avilable");
CREATE INDEX "category_index" ON "categories" ("name");
CREATE INDEX "rating_index" ON "ratings" ("rating");

----------------------------------------------------------------- Query
-- Add customers
INSERT INTO "customers" ("username", "gender", "age", "city")
VALUES
('Alice', 'female', 30, 'New York'),
('Bob', 'male', 40, 'Los Angeles'),
('Colt', 'male', 50, 'San Francisco');

-- Add categories
INSERT INTO "categories" ("name")
VALUES ('Books'), ('Drinks'), ('Electronics'), ('Shoes'), ('Stationeries');

-- Add new items to the current items
INSERT INTO "current_items" ("title", "category", "price", "number")
VALUES 
('MacBook Air', 'Electronics', 1299.00, 5),
('The Three Little Pigs', 'Books', 8.55, 15),
('Sennheiser  Wireless Bluetooth Headphones', 'Electronics', 299.95, 12),
('Coca Cola', 'Drinks', 1.00, 30),
('Nike Air Force', 'Shoes', 200.00, 3),
('Iphone 16 Pro', 'Electronics', 999.00, 1),
('Stabilo Exam Grade Eraser', 'Stationeries', 0.50, 100);

-- Add an new order for Alice:
-- Create an new order row with "id=1"
-- Add "40" items with "item_id=7" ('Stabilo Exam Grade Eraser') to the new order, and update the current items
BEGIN TRANSACTION;
INSERT INTO "orders" ("customer_id") VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Alice'));
INSERT INTO "order_details" ("order_id", "item_id", "price", "number" ) 
VALUES (1, 7, (SELECT "price" FROM "current_items" WHERE "item_id" = 7), 40);
UPDATE "current_items" SET "number" = ((SELECT "number" FROM "current_items" WHERE "item_id" = 7) - 40) WHERE "item_id" = 7;
COMMIT;

-- Add an new order for Bob:
-- Create an new order row with "id=2"
-- Add "1" item with "item_id=6" ('Iphone 16 Pro') to the new order, and delete the item
-- And add "2" item with "item_id=1" (MacBook Air) to the new order, and update the current item
BEGIN TRANSACTION;
INSERT INTO "orders" ("customer_id") VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'));
INSERT INTO "order_details" ("order_id", "item_id", "price", "number" ) 
VALUES (2, 6, (SELECT "price" FROM "current_items" WHERE "item_id" = 6), 1);
DELETE FROM "current_items" WHERE "item_id" = 6;
INSERT INTO "order_details" ("order_id", "item_id", "price", "number" ) 
VALUES (2, 1, (SELECT "price" FROM "current_items" WHERE "item_id" = 1), 3);
UPDATE "current_items" SET "number" = ((SELECT "number" FROM "current_items" WHERE "item_id" = 1) - 3) WHERE "item_id" = 1;
COMMIT;

-- Alice and Colt make comments on the item with which is "item_id=2"
INSERT INTO "comments" ("customer_id", "item_id", "content")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Alice'), 2, 'I want to but one. Do you receive cash?');
INSERT INTO "comments" ("customer_id", "item_id", "content")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Colt'), 2, 'What edition is this book?');

-- Rate the item (customer can only rate the same item once)
INSERT INTO "ratings" ("item_id", "customer_id", "rating")
VALUES (7, (SELECT "id" FROM "customers" WHERE "username" = 'Alice'), 4);
INSERT INTO "ratings" ("item_id", "customer_id", "rating")
VALUES (7, (SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 3);
INSERT INTO "ratings" ("item_id", "customer_id", "rating")
VALUES (7, (SELECT "id" FROM "customers" WHERE "username" = 'Colt'), 5);

-- Add the items which is "item_id=1, 3, 5" to Bob's watchlist
INSERT INTO "watchlists" ("customer_id", "item_id")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 1);
INSERT INTO "watchlists" ("customer_id", "item_id")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 3);
INSERT INTO "watchlists" ("customer_id", "item_id")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 5);

---------------------------- cat test.sql | sqlite3 store.db
-- Show Bob's order details
SELECT "customers"."username", "items"."title", "order_details"."price", "order_details"."number" FROM "order_details"
JOIN "orders" ON "orders"."id" = "order_details"."order_id" 
JOIN "items" ON "items"."id" = "order_details"."item_id"
JOIN "customers" ON "customers"."id" = "orders"."customer_id"
WHERE "username" = 'Bob';

-- Show the items in Bob' watchlist
SELECT "username", "title" FROM "watchlists"
JOIN "customers" ON "customers"."id" = "watchlists"."customer_id"
JOIN "items" ON "items"."id" = "watchlists"."item_id"
WHERE "username" = 'Bob';

-- Show the male customer
EXPLAIN QUERY PLAN
SELECT "username", "gender" FROM "customers" WHERE "gender" = 'male';

-- Show the current items
EXPLAIN QUERY PLAN
SELECT * FROM "current_items";

-- Show the current items whose prices are above 100
EXPLAIN QUERY PLAN
SELECT "title" "price", "number" FROM "current_items" WHERE "price" > 100;

-- Show customers who rated 'Stabilo Exam Grade Eraser' higher than 3
EXPLAIN QUERY PLAN
SELECT "title", "customers"."username", "rating" FROM "ratings"
JOIN "items" ON "items"."id" = "ratings"."item_id"
JOIN "customers" ON "customers"."id" = "ratings"."customer_id"
WHERE "title" = 'Stabilo Exam Grade Eraser' AND "rating" > 3;

-- Show the average rating of "Stabilo Exam Grade Eraser" 
EXPLAIN QUERY PLAN
SELECT "title", ROUND(AVG("rating"), 2) FROM "ratings"
JOIN "items" ON "items"."id" = "ratings"."item_id"
GROUP BY "ratings"."item_id"
HAVING "title" = 'Stabilo Exam Grade Eraser';
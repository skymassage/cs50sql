DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "items";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "order_details";
DROP TABLE IF EXISTS "rates";
DROP TABLE IF EXISTS "watchlists";
DROP TABLE IF EXISTS "comments";

DROP VIEW IF EXISTS "current_items";

DROP TRIGGER IF EXISTS "add_item";
DROP TRIGGER IF EXISTS "update_item";
DROP TRIGGER IF EXISTS "delete_item";

----------------------------------------------------------------- Tables
-- Table for item categories 
CREATE TABLE "categories" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for customers in the website
CREATE TABLE "customers" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    -- "gender" TEXT NOT NULL,
    -- "age" TEXT NOT NULL,
    -- "city" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for items in the website
CREATE TABLE "items" (
    "id" INTEGER,
    "customer_id" INTEGER,
    "title" TEXT NOT NULL,
    "category_id" INTEGER, 
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "number" INTEGER NOT NULL CHECK ("number" > 0),
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "active" INTEGER NOT NULL CHECK("active" IN (0, 1)),
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY("category_id") REFERENCES "categories"("id")
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
    "price" NUMERIC NOT NULL,
    "number" INTEGER NOT NULL CHECK("number" > 0),
    PRIMARY KEY("order_id", "item_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Table for item rates
CREATE TABLE "rates" (
    "item_id" INTEGER,
    "customer_id" INTEGER,
    "rating" INTEGER CHECK("rating" in (1, 2, 3, 4, 5)),
    PRIMARY KEY("item_id", "customer_id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Table for customers' watchlists
CREATE TABLE "watchlists" (
    "customer_id" INTEGER,
    "item_id" INTEGER,
    PRIMARY KEY("customer_id", "item_id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

-- Table for item comments
CREATE TABLE "comments" (
    "id" INTEGER,
    "customer_id" INTEGER,
    "item_id" INTEGER,
    "content" TEXT NOT NULL,
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY("item_id") REFERENCES "items"("id")
);

----------------------------------------------------------------- Views
-- View for the current items
CREATE VIEW "current_items" AS
SELECT "items"."id" AS "item_id", "username" AS "seller", "title", "categories"."name" AS "category", "price", "number", "creating_time" FROM "items"
JOIN "categories" ON "items"."category_id" = "categories"."id"
JOIN "customers" ON "items"."customer_id" = "customers"."id"
WHERE "active" = 1
ORDER BY "creating_time";

----------------------------------------------------------------- Triggers
-- Trigger for adding new items
CREATE TRIGGER "add_item"
INSTEAD OF INSERT ON "current_items"
FOR EACH ROW
BEGIN
    INSERT INTO "items" ("customer_id", "category_id", "title", "price", "number", "active")
    VALUES ((SELECT "id" FROM "customers" WHERE "username" = NEW."seller"),
            (SELECT "id" FROM "categories" WHERE "name" = NEW."category"),
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
    UPDATE "items" SET "active" = 0 WHERE "id" = OLD."item_id";
END;
---------------------------- Query

-- Add customers
INSERT INTO "customers" ("username")
VALUES
('Alice', 'helloalice'),
('Bob', 'hellobob'),
('Colt', 'hellocolt');

-- Add categories
INSERT INTO "categories" ("name")
VALUES ('Books'), ('Drinks'), ('Electronics'), ('Shoes'), ('Stationeries');

-- Add new items to the current items
INSERT INTO "current_items" ("seller", "title", "category", "price", "number")
VALUES 
('Alice', 'MacBook Air', 'Electronics', 1299.00, 5),
('Bob', 'The Three Little Pigs', 'Books', 8.55, 15),
('Colt', 'Sennheiser  Wireless Bluetooth Headphones', 'Electronics', 299.95, 12),
('Bob', 'Coca Cola', 'Drinks', 1.00, 30),
('Bob', 'Nike Air Force', 'Shoes', 200.00, 3),
('Colt', 'Iphone 16 Pro', 'Electronics', 999.00, 1),
('Colt', 'Stabilo Exam Grade Eraser', 'Stationeries', 0.50, 100);

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
VALUES (1, 1, (SELECT "price" FROM "current_items" WHERE "item_id" = 1), 2);
UPDATE "current_items" SET "number" = ((SELECT "number" FROM "current_items" WHERE "item_id" = 1) - 2) WHERE "item_id" = 1;
COMMIT;

-- Rate the item (customer can only rate the same item once)
INSERT INTO "rates" ("item_id", "customer_id", "rating")
VALUES (7, (SELECT "id" FROM "customers" WHERE "username" = 'Alice'), 4);

-- Add the item which is "item_id=3" to Bob's watchlist
INSERT INTO "watchlists" ("customer_id", "item_id")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 3);

-- Colt comments on the item with which is "item_id=2" 
INSERT INTO "comments" ("customer_id", "item_id", "content")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Colt'), 2, 'I like it');

-------------------------- Indexes

---------------------------- cat test.sql | sqlite3 store.db
SELECT * FROM "items";
SELECT * FROM "current_items";
SELECT * FROM "orders";
SELECT * FROM "rates";
SELECT * FROM "watchlists";
SELECT * FROM "comments";

DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "listings";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "order_details";
DROP TABLE IF EXISTS "rates";
DROP TABLE IF EXISTS "watchlists";
DROP TABLE IF EXISTS "comments";

DROP VIEW IF EXISTS "current_listings";

DROP TRIGGER IF EXISTS "add_listing";
DROP TRIGGER IF EXISTS "update_listing";
DROP TRIGGER IF EXISTS "delete_listing";

----------------------------------------------------------------- Tables
-- Table for listing categories 
CREATE TABLE "categories" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for users in the website
CREATE TABLE "users" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Table for listings in the website
CREATE TABLE "listings" (
    "id" INTEGER,
    "user_id" INTEGER,
    "title" TEXT NOT NULL,
    "category_id" INTEGER, 
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "number" INTEGER NOT NULL CHECK ("number" > 0),
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "active" INTEGER NOT NULL CHECK("active" IN (0, 1)),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("category_id") REFERENCES "categories"("id")
);

-- Table for users' orders
CREATE TABLE "orders" (
    "id" INTEGER,
    "user_id" INTEGER,
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

-- Table for order details
CREATE TABLE "order_details" (
    "order_id" INTEGER ,
    "listing_id" INTEGER,
    "price" NUMERIC NOT NULL,
    "number" INTEGER NOT NULL CHECK("number" > 0),
    PRIMARY KEY("order_id", "listing_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("listing_id") REFERENCES "listings"("id")
);

-- Table for listing rates
CREATE TABLE "rates" (
    "listing_id" INTEGER,
    "user_id" INTEGER,
    "score" INTEGER CHECK("score" in (1, 2, 3, 4, 5)),
    PRIMARY KEY("listing_id", "user_id"),
    FOREIGN KEY("listing_id") REFERENCES "listings"("id")
);

-- Table for users' watchlists
CREATE TABLE "watchlists" (
    "user_id" INTEGER,
    "listing_id" INTEGER,
    PRIMARY KEY("user_id", "listing_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("listing_id") REFERENCES "listings"("id")
);

-- Table for listing comments
CREATE TABLE "comments" (
    "id" INTEGER,
    "user_id" INTEGER,
    "listing_id" INTEGER,
    "content" TEXT NOT NULL,
    "creating_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("listing_id") REFERENCES "listings"("id")
);

----------------------------------------------------------------- Views
-- View for the current listings
CREATE VIEW "current_listings" AS
SELECT "listings"."id" AS "listing_id", "username" AS "seller", "title", "categories"."name" AS "category", "price", "number", "creating_time" FROM "listings"
JOIN "categories" ON "listings"."category_id" = "categories"."id"
JOIN "users" ON "listings"."user_id" = "users"."id"
WHERE "active" = 1
ORDER BY "creating_time";

----------------------------------------------------------------- Triggers
-- Trigger for adding new listings
CREATE TRIGGER "add_listing"
INSTEAD OF INSERT ON "current_listings"
FOR EACH ROW
BEGIN
    INSERT INTO "listings" ("user_id", "category_id", "title", "price", "number", "active")
    VALUES ((SELECT "id" FROM "users" WHERE "username" = NEW."seller"),
            (SELECT "id" FROM "categories" WHERE "name" = NEW."category"),
            NEW."title", NEW."price", NEW."number", 1
    );
END;

-- Trigger for updating the number of listings
CREATE TRIGGER "update_listing"
INSTEAD OF UPDATE OF "number" ON "current_listings"
FOR EACH ROW
BEGIN
    UPDATE "listings" SET "number" = NEW."number" WHERE "listings"."id" = NEW."listing_id";
END;

-- Trigger for soft deletion of sold listings which are sold out
CREATE TRIGGER "delete_listing"
INSTEAD OF DELETE ON "current_listings"
FOR EACH ROW 
BEGIN
    UPDATE "listings" SET "active" = 0 WHERE "id" = OLD."listing_id";
END;
---------------------------- Query

-- Add users
INSERT INTO "users" ("username", "password")
VALUES
('Alice', 'helloalice'),
('Bob', 'hellobob'),
('Colt', 'hellocolt');

-- Add categories
INSERT INTO "categories" ("name")
VALUES ('Books'), ('Drinks'), ('Electronics'), ('Shoes'), ('Stationeries');

-- Add new items to the current listings
INSERT INTO "current_listings" ("seller", "title", "category", "price", "number")
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
-- Add "40" items with "listing_id=7" ('Stabilo Exam Grade Eraser') to the new order, and update the current listings
BEGIN TRANSACTION;
INSERT INTO "orders" ("user_id") VALUES ((SELECT "id" FROM "users" WHERE "username" = 'Alice'));
INSERT INTO "order_details" ("order_id", "listing_id", "price", "number" ) 
VALUES (1, 7, (SELECT "price" FROM "current_listings" WHERE "listing_id" = 7), 40);
UPDATE "current_listings" SET "number" = ((SELECT "number" FROM "current_listings" WHERE "listing_id" = 7) - 40) WHERE "listing_id" = 7;
COMMIT;

-- Add an new order for Bob:
-- Create an new order row with "id=2"
-- Add "1" item with "listing_id=6" ('Iphone 16 Pro') to the new order, and delete the listing
-- And add "2" item with "listing_id=1" (MacBook Air) to the new order, and update the current listing
BEGIN TRANSACTION;
INSERT INTO "orders" ("user_id") VALUES ((SELECT "id" FROM "users" WHERE "username" = 'Bob'));
INSERT INTO "order_details" ("order_id", "listing_id", "price", "number" ) 
VALUES (2, 6, (SELECT "price" FROM "current_listings" WHERE "listing_id" = 6), 1);
DELETE FROM "current_listings" WHERE "listing_id" = 6;
INSERT INTO "order_details" ("order_id", "listing_id", "price", "number" ) 
VALUES (1, 1, (SELECT "price" FROM "current_listings" WHERE "listing_id" = 1), 2);
UPDATE "current_listings" SET "number" = ((SELECT "number" FROM "current_listings" WHERE "listing_id" = 1) - 2) WHERE "listing_id" = 1;
COMMIT;

-- Rate the listing (user can only rate the same listing once)
INSERT INTO "rates" ("listing_id", "user_id", "score")
VALUES (7, (SELECT "id" FROM "users" WHERE "username" = 'Alice'), 4);

-- Add the item which is "listing_id=3" to Bob's watchlist
INSERT INTO "watchlists" ("user_id", "listing_id")
VALUES ((SELECT "id" FROM "users" WHERE "username" = 'Bob'), 3);

-- Colt comments on the item with which is "listing_id=2" 
INSERT INTO "comments" ("user_id", "listing_id", "content")
VALUES ((SELECT "id" FROM "users" WHERE "username" = 'Colt'), 2, 'I like it');

-------------------------- Indexes

---------------------------- cat test.sql | sqlite3 store.db
SELECT * FROM "listings";
SELECT * FROM "current_listings";
SELECT * FROM "orders";
SELECT * FROM "rates";
SELECT * FROM "watchlists";
SELECT * FROM "comments";

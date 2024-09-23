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
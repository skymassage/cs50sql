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
-- And add "3" item with "item_id=1" (MacBook Air) to the new order, and update the current item
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
SELECT "username", "gender" FROM "customers" WHERE "gender" = 'male';

-- Show the current items
SELECT * FROM "current_items";

-- Show the current items whose prices are above 100
SELECT "title" "price", "number" FROM "current_items" WHERE "price" > 100;

-- Show customers who rated 'Stabilo Exam Grade Eraser' higher than 3
SELECT "title", "customers"."username", "rating" FROM "ratings"
JOIN "items" ON "items"."id" = "ratings"."item_id"
JOIN "customers" ON "customers"."id" = "ratings"."customer_id"
WHERE "title" = 'Stabilo Exam Grade Eraser' AND "rating" > 3;

-- Show the average rating of "Stabilo Exam Grade Eraser" 
SELECT "title", ROUND(AVG("rating"), 2) FROM "ratings"
JOIN "items" ON "items"."id" = "ratings"."item_id"
GROUP BY "ratings"."item_id"
HAVING "title" = 'Stabilo Exam Grade Eraser';
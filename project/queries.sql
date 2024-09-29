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
VALUES (2, 1, (SELECT "price" FROM "current_items" WHERE "item_id" = 1), 2);
UPDATE "current_items" SET "number" = ((SELECT "number" FROM "current_items" WHERE "item_id" = 1) - 2) WHERE "item_id" = 1;
COMMIT;

-- Colt comments on the item with which is "item_id=2" 
INSERT INTO "comments" ("customer_id", "item_id", "content")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Colt'), 2, 'I like it');

-- Rate the item (customer can only rate the same item once)
INSERT INTO "ratings" ("item_id", "customer_id", "rating")
VALUES (7, (SELECT "id" FROM "customers" WHERE "username" = 'Alice'), 4);

-- Add the item which is "item_id=3" to Bob's watchlist
INSERT INTO "watchlists" ("customer_id", "item_id")
VALUES ((SELECT "id" FROM "customers" WHERE "username" = 'Bob'), 3);
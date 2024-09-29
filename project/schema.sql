DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "items";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "order_details";
DROP TABLE IF EXISTS "ratings";
DROP TABLE IF EXISTS "watchlists";
DROP TABLE IF EXISTS "comments";

DROP VIEW IF EXISTS "current_items";

DROP TRIGGER IF EXISTS "add_item";
DROP TRIGGER IF EXISTS "update_item";
DROP TRIGGER IF EXISTS "delete_item";

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
    "customer_id" INTEGER,
    "item_id" INTEGER,
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
DROP TABLE IF EXISTS "categories";
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "listings";
DROP TABLE IF EXISTS "orders";
DROP TABLE IF EXISTS "order_details";
DROP TABLE IF EXISTS "rates";

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

-- Table for users' watchlists
CREATE TABLE "watchlists" (
    "user_id" INTEGER,
    "listing_id" INTEGER,
    PRIMARY KEY("user_id", "listing_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
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

----------------------------------------------------------------- Indexes

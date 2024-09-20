-- Demonstrates types in MySQL and schema for `mbta` database
-- MySQL doesn't have type affinities, it won't allow us to enter data of a different type and try to convert it.

-- Lists all databases on server
SHOW DATABASES;

-- Create `mbta` database
CREATE DATABASE IF NOT EXISTS `mbta`;
-- Instead of quotation marks, we use backticks(`) to identify the table name and other variables in the MySQL statements.

-- Use the database named "mbta" for subsequent statements or queries:
USE `mbta`;
-- This statement requires some privilege for the database or some object within it.

-- Create the "cards" table with MySQL types
CREATE TABLE `cards` (
    `id` INT AUTO_INCREMENT,
    PRIMARY KEY(`id`)
);
-- In MySQL, must use "AUTO_INCREMENT" to automatically increment the value.
-- An integer could be "TINYINT", "SMALLINT", "MEDIUMINT", "INT" or "BIGINT" based on the size of the number we want to store.

-- Use "DESCRIBE" to view table details.
DESCRIBE `cards`;
-- We will see:
-- +------------------------------------------------------+
-- | Field | Type | Null | Key | Default | Extra          |
-- +------------------------------------------------------+
-- | id    | int  | NO   | PRI | NULL    | auto_increment |
-- +------------------------------------------------------+
-- The "NULL" column above means whether this field can accept a null value, here "NO" means it never hold a null value.
-- "Default" means the default value.

-- Create the "stations" table.
CREATE TABLE `stations` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `line` ENUM('blue', 'green', 'orange', 'red') NOT NULL,
    PRIMARY KEY(`id`)
);
-- "CHAR(<len>)" and "VARCHAR(<len>)" specify the text length.
-- "CHAR" has the fixed length meaning each data has the same length.
-- "VARCHAR" has the variable length meaning the length of each data depends its actual length and can store longer text,
-- so it's usually used to store text whose length often changes.
-- MySQL also has a type "TEXT" which is used for longer chunks of text like paragraphs, pages of books etc.
-- Based on the length of the text, it could be one of: "TINYTEXT", "TEXT", "MEDIUMTEXT" and "LONGTEXT".
-- Additionally, we have the "BLOB" type to store binary strings.
-- MySQL also provides two other text types: ENUM and SET
-- "Enum" restricts a column to a single predefined option from a list of options we provide.
-- "SET" allows for multiple options to be stored in a single cell, useful for scenarios like a movie having multiple genres.
-- "UNIQUE" and "NOT NULL" in the same way as SQLite.

DESCRIBE `stations`;
-- +-------+-------------------------------------+------+-----+---------+----------------+
-- | Field | Type                                | Null | Key | Default | Extra          |
-- +-------+-------------------------------------+------+-----+---------+----------------+
-- | id    | int                                 | NO   | PRI | NULL    | auto_increment |
-- | name  | varchar(32)                         | NO   | UNI | NULL    |                |
-- | line  | enum('blue','green','orange','red') | NO   |     | NULL    |                |
-- +-------+-------------------------------------+------+-----+---------+----------------+
-- "UNI" means unique.

-- Create the "swipes" table.
CREATE TABLE `swipes` (
    `id` INT AUTO_INCREMENT,
    `card_id` INT,
    `station_id` INT,
    `type` ENUM('enter', 'exit', 'deposit') NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `amount` DECIMAL(5,2) NOT NULL CHECK(`amount` != 0),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`station_id`) REFERENCES `stations`(`id`),
    FOREIGN KEY(`card_id`) REFERENCES `cards`(`id`)
);
-- "DATE", "YEAR", "TIME", "DATETIME" and "TIMESTAMP" store our date and time values.
-- "DEFAULT CURRENT_TIMESTAMP" indicate that the timestamp should be auto-filled to store the current time if no value is provided.
-- DECIMAL(M, D), where M is the maximum number of digits (the precision)
-- and D is the number of digits to the right of the decimal point (the scale).
-- "CHECK" in the same way as SQLite.

DESCRIBE `swipes`;
-- We will see:
-- +---------------------------------------------------------------------------------------------------+
-- | Field      | Type                            | Null | Key | Default           | Extra             |
-- +---------------------------------------------------------------------------------------------------+
-- | id         | int                             | NO   | PRI | NULL              | auto_increment    |
-- | card_id    | int                             | YES  | MUL | NULL              |                   |
-- | station_id | int                             | YES  | MUL | NULL              |                   |
-- | type       | enum('enter, 'exit', 'deposit') | NO   |     | NULL              |                   |
-- | datetime   | datetime                        | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
-- | amount     | decimal(5,2)                    | NO   |     | NULL              |                   |
-- +---------------------------------------------------------------------------------------------------+
-- "MUL" in the "Key" field is for the foreign key columns, indicating that they could have repeating values since they are foreign keys.
-- "DEFAULT_GENERATED" means this is a generated column that will automatically create some value when inserting some new row.

-- Shows all tables in `mbta` database
SHOW TABLES;
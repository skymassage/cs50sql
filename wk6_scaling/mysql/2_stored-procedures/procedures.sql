-- Demonstrates stored procedures

-- Sets up database
USE `mfa`;

-- Adds deleted column (soft delete) to columns using "ADD"
ALTER TABLE `collections` ADD COLUMN `deleted` TINYINT DEFAULT 0;
-- Given that the deleted column only has values of 0 or 1, it is safe to use a TINYINT (An integer ranging from 0 to 255).

-- Creates a stored procedure to view all (non-deleted) items in collections (it's similar to view in SQLite).
delimiter //
CREATE PROCEDURE `current_collections`()
BEGIN
SELECT `title`, `accession_number`, `acquired` FROM `collections` WHERE `deleted` = 0;
END//
delimiter ;
-- In SQLite, we could type in multiple statements between a BEGIN and END and end them with a semicolon ';',
-- but MySQL recognizes ';' as a statement delimiter and prematurely ends the statement when it encounters ';'.
-- So we must redefine the delimiter temporarily to cause mysql to pass the entired statement to the server.
-- We use "delimiter" to refine the delimiter. "delimiter //" change the delimiter to "//",
-- and "delimiter ;" converts the delimiter back to ';' after the entire statement.
-- We can pass the parameters into the parentheses "()" next to the name of the procedure like functions,
-- if we need them inside of the procedure.
-- Note that we can call other procedures inside one procedure.

-- Calls the stored procedure.
CALL `current_collections`();

-- Sets an item to be deleted (soft-delete "Farmers working at dawn").
UPDATE `collections` SET `deleted` = 1 WHERE `title` = 'Farmers working at dawn';

-- Calls stored procedure again
CALL `current_collections`();

-- Creates a table to log artwork transactions
CREATE TABLE `transactions` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(64) NOT NULL,
    `action` ENUM('bought', 'sold') NOT NULL,
    PRIMARY KEY(`id`)
);

-- Creates a stored procedure with a parameter to mark artwork sold (it's similar to trigger in SQLite).
delimiter //
CREATE PROCEDURE `sell`(IN `sold_id` INT)
BEGIN
UPDATE `collections` SET `deleted` = 1 WHERE `id` = `sold_id`;
INSERT INTO `transactions` (`title`, `action`)
VALUES ((SELECT `title` FROM `collections` WHERE `id` = `sold_id`), 'sold');
END//
delimiter ;
-- Each parameter is an "IN" parameter by default. An IN parameter passes a value into a procedure.

-- Sells a piece of artwork
CALL `sell`((
    SELECT `id` FROM `collections` WHERE `title` = 'Farmers working at dawn'
));

-- Shows results
SELECT * FROM `transactions`;
SELECT * FROM `collections`;

-- Delete procecure to later improve it
DROP PROCEDURE `sell`;

-- If we call sell on the same ID more than once, it will add multiple times to the "transactions" table.
-- So we use the logic syntax, like "IF, ELSEIF, ELSE, THEN, LOOP, REPEAT ,WHILE..." , to improve it.
-- Besides, if the delted item has been delted again, the error message will be raised using "SIGNAL SQLSTATE '45000'".
-- The SIGNAL statement signals an error or warning condition, and an SQLSTATE value can indicate errors, warnings, or not found.
-- Here '45000' means "unhandled user-defined exception".
-- Creates a stored procedure to handle case where item is already deleted (avoid deleting again).
delimiter //
CREATE PROCEDURE `sell`(IN `sold_id` INT)
BEGIN
IF `sold_id` NOT IN (
    SELECT `id` FROM `collections` WHERE `deleted` = 0
) THEN
    SIGNAL SQLSTATE '45000';
END IF;
UPDATE `collections` SET `deleted` = 1 WHERE `id` = `sold_id`;
INSERT INTO `transactions` (`title`, `action`)
VALUES ((SELECT `title` FROM `collections` WHERE `id` = `sold_id`), 'sold');
END//
delimiter ;
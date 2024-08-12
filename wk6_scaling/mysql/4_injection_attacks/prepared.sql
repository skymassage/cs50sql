-- Demonstrates prepared statements

Use `bank`;

-- A prepared statement is a statement in SQL that we can later insert values into.
-- Creates a prepared statement: PREPARE <statement_name> FROM <statement>;
PREPARE `balance_check`
FROM 'SELECT * FROM `accounts` WHERE `id` = ?';
-- The question mark in the prepared statement acts as a safeguard against the unintended execution of SQL code.

-- To actually run this statement now and check someone's balance,
-- we accept user input as a variable and then plug it into the prepared statement.
SET @id = 1;
-- Imagine the "SET" statement to get the user's ID through the application,
-- where '@' is a convention for variables in MySQL.
-- Executes the prepared statement with non-malicious input "1".
EXECUTE `balance_check` USING @id;

-- The malicious input "1 UNION SELECT * FROM `accounts`" will show all rows.
SELECT * FROM `accounts` WHERE `id` = 1
UNION
SELECT * FROM `accounts`;

-- Executes the prepared statement with malicious input "1 UNION SELECT * FROM `accounts`"
SET @id = '1 UNION SELECT * FROM `accounts`';
EXECUTE `balance_check` USING @id;
-- It just showed one row, as the result of giving the non-malicious input "1".
-- The prepared statement does something called escaping.
-- It finds all the portions of the variable that could be malicious and escapes them so they don't actually get executed.
-- So the prepared statement cleans up input to ensure that no malicious SQL code is injected,

-- Check the variable "id".
SELECT @id;
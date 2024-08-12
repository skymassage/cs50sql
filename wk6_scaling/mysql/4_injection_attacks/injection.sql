-- Demonstrates SQL injection attacks.

Use `bank`;

-- Executes statement with non-malicious input "1".
SELECT * FROM `accounts` WHERE `id` = 1;

-- Executes statement with malicious input "1 UNION SELECT * FROM `accounts`",
-- i.e., the hacker sent "1 UNION SELECT * FROM `accounts`" to the database.
SELECT * FROM `accounts` WHERE `id` = 1
UNION
SELECT * FROM `accounts`;
-- It showed all rows.

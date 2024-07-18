-- Use "ALTER TABLE" and "MODIFY" to alter tables.
-- Add one more option "silver" to the column "line" in the "stations".
ALTER TABLE `stations`
MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;
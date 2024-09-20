-- Use "ALTER TABLE" and "MODIFY" to alter tables.
-- Add one more option "silver" to the column "line" in the "stations".
ALTER TABLE `stations`
MODIFY `line` ENUM('blue', 'green', 'orange', 'red', 'silver') NOT NULL;

-- Add the column "line" to "cards".
ALTER TABLE `cards` ADD COLUMN `holder` VARCHAR(32) NOT NULL;
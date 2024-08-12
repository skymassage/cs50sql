-- Demonstrates granting and revoking privileges in MySQL

Use `rideshare`;

-- Creates a new user with username 'carter' and password 'password'
CREATE USER 'carter' IDENTIFIED BY 'password';

-- As Carter, fails to show databases
SHOW DATABASES;

-- As root user, grants SELECT privileges on only the `analysis` view in the `rideshare` database
GRANT SELECT ON `rideshare`.`analysis` TO 'carter';

-- As Carter, succeeds in showing `rideshare` database
SHOW DATABASES;
USE `rideshare`;

-- As Carter, succeeds in selecting from `analysis`
SELECT * FROM `analysis`;

-- As Carter, fails to select from `rides` table
SELECT * FROM `rides`;

-- As Carter, fails to create a new view
CREATE VIEW `destinations` AS
SELECT `destination` FROM `analysis`;

-- As root user, grants privileges to 'carter' to create a view on any table in the `ridershare` database
GRANT CREATE VIEW ON `rideshare`.* TO 'carter';

-- As Carter (log in as Carter again and use `rideshare`), succeeds in creating a view
CREATE VIEW `destinations` AS
SELECT `destination` FROM `analysis`;

-- The "destinations" view is regarded as a table here.
SHOW TABLES;

-- As root user, grants DROP privileges on the `destinations` view in the `rideshare` database.
-- Note that the "destinations" view is regarded as a table, so use "TABLE" instead of "VIEW".
GRANT DROP ON TABLE `rideshare`.`destinations` TO 'carter';

-- As carter user, drop the "destinations" view. Note that use "VIEW" when removing views.
DROP VIEW IF EXISTS `destinations`;

-- As root user, create another user "alice" also with the password 'passsword'
CREATE USER 'alice' IDENTIFIED BY 'password';

-- -- As root user, grants multiple permissions to the `rideshare` database to multiple users.
GRANT SELECT, INSERT, UPDATE ON `rideshare`.* TO 'carter', 'alice';

-- As root user, grant all permissions to carter.
GRANT ALL PRIVILEGES ON *.* TO 'carter';

-- Show the user's granted permissions (except for the root user, only you can see your privileges).
SHOW GRANTS FOR 'carter';
SHOW GRANTS FOR 'alice';

-- As root user, revoke all priviveles from users.
REVOKE ALL PRIVILEGES ON *.* FROM 'carter';
REVOKE SELECT, INSERT, UPDATE ON `rideshare`.* FROM 'alice';

-- As root user, show all user and their hosts.
SELECT `user`, `host` FROM `mysql`.`user`;

-- Remove databases.
DROP DATABASE `rideshare`;

-- As root user, remove users.
DROP USER IF EXISTS 'carter', 'alice';

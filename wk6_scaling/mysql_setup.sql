-- Demonstrates navigating a MySQL database

-- Starts MySQL server using Docker (note that go the "cs50sql" folder).
docker run --name mysql -p 80:3306 -v $(pwd)/wk6_scaling:/mnt:ro -e MYSQL_ROOT_PASSWORD=123 -d mysql
docker run --name mysql -p 3306:3306 -v $(pwd)/wk6_scaling:/mnt:ro -e MYSQL_ROOT_PASSWORD=123 -d mysql
-- Bind to our host so that we can pass our sql files into the container for execution.

-- Restart the container if you stop it,
-- otherwise you will see "ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1:3306' (111)".
docker start mysql

-- Run "mysql -u root -h 127.0.0.1 -P 3306 -p" in the mysql container
-- with the "root" username whose passwaor is "123" to connect the server:
docker exec -it mysql mysql -u root -h 127.0.0.1 -P 3306 -p
-- "-u" indicates the username of the MySQL account to use for connecting to the server.
-- "-h" connects to the MySQL server on the given host, and here "127.0.0.1" the IP address of the hostname "localhost".
-- "-P" is the port number to use, and "3306" is the default port where MySQL is hosted.
-- "-p" indicates that we want to be prompted for a password when connecting.

-- Check the path "/mnt" in the volume of the "mysql" container.
docker exec mysql ls /mnt

-- Lists all databases on server
SHOW DATABASES;

-- Shows all tables
SHOW TABLES;

-- Use "DESCRIBE" to view table details.
DESCRIBE `<table>`;

-- Quit the MySQL.
quit
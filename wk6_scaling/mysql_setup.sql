-- Demonstrates navigating a MySQL database

-- Starts MySQL server using Docker (note that go the "cs50sql" folder).
docker container run --name mysql -p 3306:3306 -v $(pwd)/wk6_scaling:/mnt:ro -e MYSQL_ROOT_PASSWORD=123 -d mysql

-- Connect to a MySQL server with the "root" username whose passwaor is "123":
mysql -u root -h 127.0.0.1 -P 3306 -p
-- "-u" indicates the username of the MySQL account to use for connecting to the server.
-- "-h" connects to the MySQL server on the given host, and here "127.0.0.1" the IP address of the hostname "localhost".
-- "-P" is the port number to use, and "3306" is the default port where MySQL is hosted.
-- Think of the combination of host and port as the address of the database we are trying to connect to.
-- "-p" indicates that we want to be prompted for a password when connecting.
-- So we can use "mysql -u <username> -h 127.0.0.1 -P 3306 -p" to connect the MySQL server.

-- Restart docker container if you see "ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1:3306' (111)":
docker start mysql

-- Check the path "/mnt" in the volume of the "mysql" container.
docker exec mysql ls /mnt

-- Lists all databases on server
SHOW DATABASES;

-- Quit the MySQL.
quit
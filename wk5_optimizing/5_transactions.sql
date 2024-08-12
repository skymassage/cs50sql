--------------------------------------------------------------- Open bank.db
UPDATE "accounts" SET "balance" = 10 WHERE "name" = 'Alice';
UPDATE "accounts" SET "balance" = 20 WHERE "name" = 'Bob';
UPDATE "accounts" SET "balance" = 30 WHERE "name" = 'Charlie';
--------------------------------------------------------------- Demonstrate transactions

-- For example, Alice is trying to send $10 to Bob.
-- First, we can need to add $10 to Bob's account and then subtract $10 from Alice's account.
-- If someone sees the database after the first update to Bob's account but before the second update to Alice's account,
-- they could get an incorrect understanding of the total amount of money held by the bank. The SQL operation as below: 
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob';
SELECT * FROM "accounts"; -- Viewing here provides an improper view of total balances
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice';
SELECT * FROM "accounts"; -- Viewing here, after all updated, results in proper view

-- Reset the tables.
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Bob';
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Alice';

------------------------------------------------------------------------------

-- To an outside observer, it should seem like the different parts of a transaction happen all at once.
-- A transaction is a sequence of SQL statements on a database as a single logical unit of work.
-- If any of the statement fail, the entire transaction fails. 
-- The effects of all the SQL statements in a transaction can be either all committed (applied to the database)
-- or all rolled back (undone from the database).
-- A database transaction must be atomic, consistent, isolated and durable.
-- atomicity: transaction can't be broken down into smaller pieces,
-- consistency: should not violate a database constraint,
-- isolation: if multiple users access a database, their transactions cannot interfere with each other,
-- durability: in case of any failure within the database, all data changed by transactions will remain.

-- Create a transaction which is successful
BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob';
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice';
COMMIT;
-- Notice the UPDATE statements are written in between the commands to begin the transaction (BEGIN TRANSACTION;) and to commit it (COMMIT;). 
-- If someone views the database in the other terminals 
-- when we are executing the UPDATE statements after "BEGIN TRANSACTION;" but before "COMMIT;",
-- they wouldn't see any change in the database from us until we execute "COMMIT;".
-- This helps keep the transaction atomic. 

------------------------------------------------------------------------------

-- If we tried to run the above transaction again, Alice tries to pay Bob another $10,
-- it should fail to run because Alice's account balance is at 0. 
-- Because the "balance" column in accounts has a check constraint to ensure that it has a non-negative value.

-- Shows schema, higlight CHECK constraint
.schema
-- Completes invalid update of balance without a transaction
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob';
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice'; -- Invokes constraint error.
-- Rolls back the balance
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Bob';

-- The way we implement reverting the transaction is using "ROLLBACK".
-- Once we begin a transaction and write some SQL statements, if any of them fail,
-- we can end it with a "ROLLBACK" to revert all values to their pre-transaction state. 
-- This helps keep transactions consistent.
-- Creates a transaction which should be rolled back
BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob';
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice'; -- Invokes constraint error, which is aborted.
ROLLBACK;

------------------------------------------------------------------------------

-- A race condition occurs when multiple entities simultaneously access and make decisions based on a shared value,
-- potentially causing inconsistencies in the database.
-- Unresolved race conditions can be exploited by hackers to manipulate the database.
-- However, transactions are processed in isolation to avoid the inconsistencies in the first place.
-- Each transaction dealing with similar data from our database will be processed sequentially.
-- This helps prevent the inconsistencies that an adversarial attack can exploit.
-- To make transactions sequential, SQLite and other database management systems use locks on databases.
-- A table in a database could be in a few different states:
-- UNLOCKED: This is the default state when no user is accessing the database.
-- SHARED: When a transaction is reading data from the database,
--         it obtains shared lock that allows other transactions to read simultaneously from the database.
-- EXCLUSIVE: If a transaction needs to write or update data, it obtains an exclusive lock on the database
--            that does not allow other transactions to occur at the same time (not even a read).

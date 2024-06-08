--------------------------------------------------------------- Open movies.db

-- SQLite allows us to "vacuum" data, this cleans up previously deleted data
-- (The previously deleted data is actually not deleted, but just marked as space being available for the next INSERT).
-- To check the size of "movies.db" on the terminal, we can use a Unix command: du -b movies.db

-- Drop existing indexes
DROP INDEX IF EXISTS "title_index";
DROP INDEX IF EXISTS "people_index";
DROP INDEX IF EXISTS "name_index";
DROP INDEX IF EXISTS "recents";
-- Even we delete the above data, the size of "movies.db" is still the same.

-- To actually clean up the deleted space, we can run the command "VACUUM" in the SQLite.
VACUUM;
-- This might take a second or two to run. After vacuuming, the size of "movies.db" will be smaller.
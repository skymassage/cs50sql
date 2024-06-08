-- Given two usernames, lovelytrust487 and exceptionalinspiration482, find the user IDs of their mutual friends.
-- Ensure your query uses the index sqlite_autoindex_friends_1.
-- Method 1:
WITH "view" AS (
    SELECT * FROM "users" JOIN "friends" ON "friends"."user_id" = "users"."id"
)
SELECT "friend_id" FROM "view" WHERE "username" = 'lovelytrust487'
INTERSECT
SELECT "friend_id" FROM "view" WHERE "username" = 'exceptionalinspiration482';

-- Method 2:
SELECT "friend_id" FROM "friends" WHERE "user_id" = (
    SELECT "id" FROM "users" WHERE "username" = 'lovelytrust487'
)
INTERSECT
SELECT "friend_id" FROM "friends" WHERE "user_id" = (
    SELECT "id" FROM "users" WHERE "username" = 'exceptionalinspiration482'
);

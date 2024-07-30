-- Find the players among the 10 cheapest players per hit and among the 10 cheapest players per RBI in 2001.
-- Return two columns, one for the players' first names and one of their last names.
-- You can calculate a player's salary per RBI by dividing their 2001 salary by their number of RBIs in 2001.
-- You may assume, for simplicity, that a player will only have one salary and one performance in 2001.
-- Order your results by alphabetically by last name.
SELECT "first_name", "last_name" FROM (
    SELECT "first_name", "last_name" FROM "players"
    JOIN "salaries" ON "players"."id" = "salaries"."player_id"
    JOIN "performances" ON "players"."id" = "performances"."player_id"
    WHERE "salaries"."year" = 2001 AND "performances"."year" = 2001 AND ("salary" / "H") IS NOT NULL
    ORDER BY ("salary" / "H") LIMIT 10
)
INTERSECT
SELECT "first_name", "last_name" FROM (
    SELECT "first_name", "last_name" FROM "players"
    JOIN "salaries" ON "players"."id" = "salaries"."player_id"
    JOIN "performances" ON "players"."id" = "performances"."player_id"
    WHERE "salaries"."year" = 2001 AND "performances"."year" = 2001 AND ("salary" / "RBI") IS NOT NULL
    ORDER BY ("salary" / "RBI") LIMIT 10
)
ORDER BY "last_name";
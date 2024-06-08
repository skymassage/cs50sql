-- Find the top 5 teams, sorted by the total number of hits by players in 2001.
-- Return two columns, one for the teams' names and one for their total hits in 2001.
-- Call the column representing total hits by players in 2001 "total hits" and sort by total hits, highest to lowest.
SELECT "name", SUM("H") AS "total hits" FROM "teams"
JOIN "performances" on "performances"."team_id" = "teams"."id"
WHERE "performances"."year" = 2001
GROUP BY "team_id"
ORDER BY SUM("H") DESC LIMIT 5;

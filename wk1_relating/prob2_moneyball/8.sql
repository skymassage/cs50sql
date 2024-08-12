-- Find the 2001 salary of the player who hit the most home runs in 2001.
-- Rreturn a table with one column, the salary of the player.
-- Note that layers can have more than one home run record and salary in the same year because they can change teams.
SELECT "salary" FROM "salaries" WHERE "player_id" = (
    SELECT "player_id" FROM "performances" WHERE "HR" = (
        SELECT MAX("HR") FROM "performances" WHERE "year" = 2001
    )
) AND "year" = 2001;
-- Or
SELECT "salaries"."salary" FROM "salaries"
JOIN "performances" ON "salaries"."player_id" = "performances"."player_id"
WHERE "performances"."HR" = (
    SELECT MAX("HR") from "performances" WHERE "year" = 2001
) AND "salaries"."year" = 2001;

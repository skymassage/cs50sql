-- Ffind all teams that Satchel Paige played for. Return a table with a single column, one for the name of the teams.
SELECT "name" FROM "teams" WHERE "id" IN (
    SELECT "team_id" FROM "performances" WHERE "player_id" = (
        SELECT "id" FROM "players" WHERE "first_name" = 'Satchel' AND "last_name" = 'Paige'
    )
);

-- Find the name(s) of the school district(s) with the single least number of pupils.
SELECT "name" FROM (
    SELECT "name", MIN("pupils") FROM "districts" JOIN "expenditures" ON "districts"."id" = "expenditures"."district_id"
);
-- Or
-- SELECT "d"."name" FROM "districts" AS "d" JOIN "expenditures" AS "e" ON "d"."id" = "e"."district_id" ORDER BY "e"."pupils" LIMIT 1;

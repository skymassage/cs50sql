-- Find the district name of the highest per pupils expenditure
SELECT "name" FROM "districts" JOIN "expenditures" ON "expenditures"."district_id" = "districts"."id"
WHERE "per_pupil_expenditure" = (
    SELECT MAX("per_pupil_expenditure") FROM "expenditures"
);

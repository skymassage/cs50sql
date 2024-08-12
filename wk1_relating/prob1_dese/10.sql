-- Find the 10 public school districts with the highest per-pupil expenditures.
-- Return the names of the districts and the per-pupil expenditure for each.
SELECT "name", "per_pupil_expenditure" FROM "districts"
JOIN "expenditures" ON "expenditures"."district_id" = "districts"."id"
WHERE "type" = 'Public School District'
ORDER BY "per_pupil_expenditure" DESC LIMIT 10;

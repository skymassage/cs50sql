-- Create or open mbta.db using sqlite3 mbta.db
-- Use DROP to delete prior tables if they exist
DROP TABLE IF EXISTS "riders";
DROP TABLE IF EXISTS "stations";
DROP TABLE IF EXISTS "visits";
DROP TABLE IF EXISTS "swipes";
DROP TABLE IF EXISTS "cards";

-- Creates three tables without specified type affinities

CREATE TABLE "riders" (
    "id",
    "name"
);

CREATE TABLE "stations" (
    "id",
    "name",
    "line"
);

CREATE TABLE "visits" (
    "rider_id",
    "station_id"
);

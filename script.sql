CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS calculation_table (
    id            UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    source        UUID NOT NULL DEFAULT uuid_generate_v4(),
    target        UUID NOT NULL DEFAULT uuid_generate_v4(),
    cost          int NOT NULL,
    reverse_cost  int NOT NULL,
    x1            float NOT NULL,
    y1            float NOT NULL,
    x2            float NOT NULL,
    y2            float NOT NULL,
    UNIQUE (x1, y1, x2, y2)
);

 WITH points as
 (
	 WITH sample as 
		(
			WITH area as
			(
				SELECT ST_Transform(
					ST_GeomFromGeoJSON('{"coordinates": [[[-75.68902456859064,40.0340143735292],[-75.68902456859064,39.927747431953776],[-75.53255688544492,39.927747431953776],[-75.53255688544492,40.0340143735292],[-75.68902456859064,40.0340143735292]]],"type": "Polygon"}'),
					4326
				) as geometry
			)
			SELECT (ST_SquareGrid(.001, geometry)).geom
			FROM
				area
		)
	-- 	SELECT ST_AsText(ST_ExteriorRing(geom))
		SELECT  ST_AsText(ST_PointN(ST_ExteriorRing(geom), 1)) as point_one,
				ST_AsText(ST_PointN(ST_ExteriorRing(geom), 2)) as point_two,
				ST_AsText(ST_PointN(ST_ExteriorRing(geom), 3)) as point_three,
				ST_AsText(ST_PointN(ST_ExteriorRing(geom), 4)) as point_four
		FROM sample
)
INSERT INTO calculation_table (
    cost, reverse_cost, x1, y1, x2, y2
) SELECT 
-- (
    1, 1, ST_X(points.point_one), ST_Y(points.point_one), ST_X(points.point_two), ST_Y(points.point_two)
-- )
-- ,
-- (
--     1, 1, ST_X(points.point_two), ST_Y(points.point_two), ST_X(points.point_three), ST_Y(points.point_three)
-- ),
-- (
--     1, 1, ST_X(points.point_three), ST_Y(points.point_three), ST_X(points.point_four), ST_Y(points.point_four)
-- ),
-- (
--     1, 1, ST_X(points.point_four), ST_Y(points.point_four), ST_X(points.point_one), ST_Y(points.point_one)
-- )
FROM
    points;

SELECT count(*) FROM calculation_table;

DROP TABLE calculation_table;
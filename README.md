# Auto Routing Research

TODO:

- [ ] Postgis docker container
- [ ] Set of scripts that connect into postgres/postgis
- [ ] Grafana instance to render visualization
- [ ] Script with fake results to change weights
- [ ] Add constraints into the mix

## Demonstration

Polygon as GeoJson

    {
        "coordinates": [
          [
            [
              -75.68902456859064,
              40.0340143735292
            ],
            [
              -75.68902456859064,
              39.927747431953776
            ],
            [
              -75.53255688544492,
              39.927747431953776
            ],
            [
              -75.53255688544492,
              40.0340143735292
            ],
            [
              -75.68902456859064,
              40.0340143735292
            ]
          ]
        ],
        "type": "Polygon"
    }

Convert to Geometry in Postgis (Remove ST_AsText to visualize)

    SELECT ST_AsText(ST_GeomFromGeoJSON('{"coordinates": [[[-75.68902456859064,40.0340143735292],[-75.68902456859064,39.927747431953776],[-75.53255688544492,39.927747431953776],[-75.53255688544492,40.0340143735292],[-75.68902456859064,40.0340143735292]]],"type": "Polygon"}')) As wkt;

Generate a grid of arbitrary size

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
    SELECT geom
    FROM sample

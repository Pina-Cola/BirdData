-- x is latitude
-- y is longitude
-- https://www.geeksforgeeks.org/program-distance-two-points-earth/
CREATE OR REPLACE FUNCTION distance(x1 real,y1 real,x2 real,y2 real) RETURNS float AS $$
DECLARE
    -- Radius of earth in kilometers.
    r int := 6371;
    a real := 0;
    c real := 0;
    dlon real := 0;
    dlat real := 0;
    -- The math module contains a function named
    -- radians which converts from degrees to radians.
    lon1 real := radians(y1);
    lon2 real := radians(y2);
    lat1 real := radians(x1);
    lat2 real := radians(x2);
BEGIN
    -- Haversine formula
    dlon := lon2 - lon1;
    dlat := lat2 - lat1;
    a := sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2;
    c := 2 * asin(sqrt(a));
    -- calculate the result
    RETURN (c * r);
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- Returns true if the two points are in distance "in_dis" from each other.
-- Uses function "distance" to calculate distance between two points
-- x is latitude
-- y is longitude
CREATE OR REPLACE FUNCTION in_distance(x real,y real,xp real,yp real,in_dis real) RETURNS BOOLEAN AS $$
DECLARE
    dis float := 0;
BEGIN
    dis := (SELECT distance(x,y,xp,yp));

    IF (dis < in_dis) THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;


-- Latitude is denoted by Y (northing) and Longitude by X (Easting)
CREATE OR REPLACE FUNCTION id_distance(id1 int,id2 int) RETURNS float AS $$
DECLARE
    lon1 real := 0;
    lon2 real := 0;
    lat1 real := 0;
    lat2 real := 0;
BEGIN
    lon1 := (SELECT easting from dw_coordinates where id = id1);
    lon2 := (SELECT easting from dw_coordinates where id = id2);
    lat1 := (SELECT northing from dw_coordinates where id = id1);
    lat2 := (SELECT northing from dw_coordinates where id = id2);

    RETURN (SELECT distance(lat1,lon1,lat2,lon2));
END;
$$ LANGUAGE plpgsql;


-- Latitude is denoted by Y (northing) and Longitude by X (Easting)
CREATE OR REPLACE FUNCTION id_in_distance(id1 int,id2 int,in_dis real) RETURNS BOOLEAN AS $$
DECLARE
    dis float := 0;
BEGIN
    dis := (SELECT id_distance(id1,id2));

    IF (dis < in_dis) THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*
-- GETS ALL distances between two images.¨

SELECT images1.filename, images2.filename, distance(lat1, lon1, lat2, lon2) as dist
FROM (SELECT filename, latitude as lat1, longitude as lon1
      FROM images WHERE latitude::int != 0) images1,
    (SELECT filename, latitude as lat2, longitude as lon2
     FROM images WHERE latitude::int != 0) as images2;
*/

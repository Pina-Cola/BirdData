drop function if EXISTS build_data_warehouse(real, real);
drop function if EXISTS insert_nests();
drop function if EXISTS insert_rings();
drop function if EXISTS insert_images();
drop function if EXISTS insert_reports();
drop function if EXISTS insert_videos();


/* Insert values into DW_image_to_nest*/
CREATE OR REPLACE FUNCTION insert_image_to_nest(dis real)
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_image_to_nest(nest_id, file_path, distance)
            SELECT nest_id, file_path, id_distance(n.coordinates, i.coordinates) FROM DW_nests AS n, DW_images AS i
            WHERE id_in_distance(n.coordinates, i.coordinates, dis)
            AND EXTRACT(year FROM discover_date) = EXTRACT(year FROM date_time);

    END;
$$
LANGUAGE plpgsql;



/* Insert values into DW_ring_to_nest*/
CREATE OR REPLACE FUNCTION insert_ring_to_nest(dis real)
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_ring_to_nest(nest_id, ring_id, distance)
            SELECT nest_id, ring_id, id_distance(n.coordinates, r.coordinates) FROM DW_nests AS n, DW_rings AS r
            WHERE id_in_distance(n.coordinates, r.coordinates, dis)
            AND EXTRACT(year FROM discover_date) = EXTRACT(year FROM date_time);

    END;
$$
LANGUAGE plpgsql;


/* Insert values into DW_videos*/
CREATE OR REPLACE FUNCTION insert_videos()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_videos(file_path, file_name, nest_id)
            SELECT filepath, filename, nest_id FROM videos;

    END;
$$
LANGUAGE plpgsql;



/* Insert values into DW_samples*/
CREATE OR REPLACE FUNCTION insert_samples()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_coordinates(northing, easting)
            SELECT northing, easting FROM sample_data
            ON CONFLICT DO NOTHING;

        INSERT INTO DW_samples(sample_id, nest_id, description, coordinates)
            SELECT sample_id, nest_ID, description, c.id
            FROM sample_data AS s JOIN DW_coordinates AS c
            ON c.northing = s.northing AND c.easting = s.easting
            ON CONFLICT DO NOTHING;
    END;
$$
LANGUAGE plpgsql;


/* Insert values into DW_reports*/
CREATE OR REPLACE FUNCTION insert_reports()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_reports(nest_ID, observation)
            SELECT nest_ID, description FROM fejkrapport_docx;
    END;
$$
LANGUAGE plpgsql;


/* Insert values into DW_images and DW_coordinates */
CREATE OR REPLACE FUNCTION insert_images()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_coordinates(northing, easting)
            SELECT latitude, longitude FROM images
            ON CONFLICT DO NOTHING;

        INSERT INTO DW_images(file_path, file_name, date_time, coordinates)
            SELECT filepath, filename, date_time, c.id
            FROM images AS i JOIN DW_coordinates AS c
            ON c.northing = i.latitude AND c.easting = i.longitude;

    END;
$$
LANGUAGE plpgsql;




/* Insert values into DW_rings and DW_coordinates */
CREATE OR REPLACE FUNCTION insert_rings()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_coordinates(northing, easting)
            SELECT northing, easting FROM ringmarkningsdata
            ON CONFLICT DO NOTHING;

        INSERT INTO DW_rings(ring_ID, species, age, place, city, date_time, link, coordinates)
            SELECT rd.ring_id, species, age, place, city, CAST(REPLACE(date_time, 'kl. ', '') AS timestamp), maps_link, coordinates
            FROM (SELECT ring_ID, maps_link, c.id AS coordinates FROM ringmarkningsdata AS r, DW_coordinates AS c where r.easting = c.easting AND r.northing = c.northing)
            AS rd JOIN ringmarkning_2021_docx as r2
            ON rd.ring_id=r2.ring_id;

    END;
$$
LANGUAGE plpgsql;


/* Insert values into DW_nests */
CREATE OR REPLACE FUNCTION insert_nests()
    RETURNS VOID
    AS
    $$
    BEGIN

        INSERT INTO DW_coordinates(northing, easting)
            SELECT northing, easting FROM nests_2021
            ON CONFLICT DO NOTHING;

        INSERT INTO DW_coordinates(northing, easting)
            SELECT northing, easting FROM nests_2022
            ON CONFLICT DO NOTHING;

        INSERT INTO DW_nests(nest_ID, place, discover_date, link, crop, coordinates)
            SELECT nest_id, place, CAST(discovered AS date) AS d, maps_link, crop, c.id AS coordinates
            FROM nests_2021 AS n, DW_coordinates AS c
            WHERE c.northing = n.northing AND c.easting = n.easting;

        INSERT INTO DW_nests(nest_ID, place, discover_date, link, crop, coordinates)
            SELECT nest_id, place, CAST(discovered AS date) AS d, maps_link, crop, c.id as coordinates
            FROM nests_2022 AS n, DW_coordinates AS c
            WHERE c.northing = n.northing AND c.easting = n.easting;
    END;
$$
LANGUAGE plpgsql;


/* Builds the data warehouse*/
CREATE OR REPLACE FUNCTION build_data_warehouse(dist_nest real, dist_image real)
    RETURNS VOID
    AS
    $$
    BEGIN



        drop table DW_ring_to_nest;
        drop table DW_image_to_nest;
        drop table DW_rings;
        drop table DW_images;
        drop table DW_reports;
        drop table DW_samples;
        drop table DW_videos;
        drop table DW_nests;
        drop table DW_coordinates;


        /* Create table DW_rings */
        CREATE TABLE DW_coordinates(
            id SERIAL PRIMARY KEY,
            northing real,
            easting real,
            CONSTRAINT coordinates_u UNIQUE(northing, easting)
        );

        /* Create table DW_nests */
        CREATE TABLE DW_nests (
            nest_ID varchar(50) PRIMARY KEY,
            place text,
            discover_date date,
            link text,
            crop varchar(50),
            coordinates int,
            CONSTRAINT coordinates_c FOREIGN KEY(coordinates) REFERENCES DW_coordinates(id)
        );

        /* Create table DW_rings */
        CREATE TABLE DW_rings(
            ring_ID int PRIMARY KEY,
            species varchar(50),
            age varchar(50),
            place text,
            city varchar(50),
            date_time timestamp,
            link text,
            coordinates int,
            CONSTRAINT coordinates_c FOREIGN KEY(coordinates) REFERENCES DW_coordinates(id)
        );

        /* Create table DW_images */
        CREATE TABLE DW_images(
            file_path text PRIMARY KEY,
            file_name varchar(50),
            date_time timestamp,
            coordinates int,
            CONSTRAINT coordinates_ci FOREIGN KEY(coordinates) REFERENCES DW_coordinates(id)
        );


        /* Create table DW_reports */
        CREATE TABLE DW_reports(
            nest_ID varchar(50),
            observation text,
            CONSTRAINT id_c FOREIGN KEY(nest_ID) REFERENCES DW_nests(nest_ID)
        );


        /* Create table DW_samples */
        CREATE TABLE DW_samples(
            sample_id varchar(50) PRIMARY KEY,
            nest_id varchar(50),
            description text,
            coordinates int,
            CONSTRAINT coordinates_c FOREIGN KEY(coordinates) REFERENCES DW_coordinates(id),
            CONSTRAINT id_cs FOREIGN KEY(nest_ID) REFERENCES DW_nests(nest_ID)
        );

        /* Create table DW_videos */
        CREATE TABLE DW_videos(
            file_path text PRIMARY KEY,
            file_name varchar(50),
            nest_id varchar(50),
            CONSTRAINT id_cv FOREIGN KEY(nest_ID) REFERENCES DW_nests(nest_ID)
        );

        CREATE TABLE DW_ring_to_nest(
            nest_id varchar(50),
            ring_id int,
            distance real,
            CONSTRAINT id_c FOREIGN KEY(nest_id) REFERENCES DW_nests(nest_ID),
            CONSTRAINT ring_c FOREIGN KEY(ring_id) REFERENCES DW_rings(ring_ID)
        );

        CREATE TABLE DW_image_to_nest(
            nest_id varchar(50),
            file_path text,
            distance real,
            CONSTRAINT id_c FOREIGN KEY(nest_id) REFERENCES DW_nests(nest_ID),
            CONSTRAINT file_c FOREIGN KEY(file_path) REFERENCES DW_images(file_path)
        );


        PERFORM insert_nests();
        PERFORM insert_rings();
        PERFORM insert_images();
        PERFORM insert_reports();
        PERFORM insert_samples();
        PERFORM insert_videos();
        PERFORM insert_ring_to_nest(dist_nest);
        PERFORM insert_image_to_nest(dist_image);


    END;
$$
LANGUAGE plpgsql;

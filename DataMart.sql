DROP FUNCTION get_bundle(varchar);


CREATE OR REPLACE FUNCTION create_bundle(id varchar)
RETURNS void

   AS
   $$
   BEGIN

   DROP TABLE if EXISTS mart;

   CREATE TABLE Mart (
       nest_id varchar(50),
       link text,
       image_path text,
       bird_id int,
       video_path text,
       report text,
       CONSTRAINT nest_id FOREIGN KEY(nest_id) REFERENCES DW_nests(nest_id),
       CONSTRAINT bird_id FOREIGN KEY(bird_id) REFERENCES DW_rings(ring_id),
       CONSTRAINT file_path FOREIGN KEY(image_path) REFERENCES DW_images(file_path)
   );

    INSERT INTO Mart(nest_id, link, image_path, bird_id, video_path, report)
        SELECT nest_id, link, null, null, null, null FROM DW_nests WHERE nest_id = id;

    INSERT INTO Mart(nest_id, link, image_path, bird_id, video_path, report)
        SELECT nest_id, null, file_path, null AS image_path, null, null FROM DW_image_to_nest WHERE nest_id = id;

    INSERT INTO Mart(nest_id, link, image_path, bird_id, video_path, report)
        SELECT nest_id, null, null, ring_id AS bird_id, null, null FROM DW_ring_to_nest WHERE nest_id = id;

    INSERT INTO Mart(nest_id, link, image_path, bird_id, video_path, report)
        SELECT nest_id, null, null, null, file_path AS video_path, null FROM DW_videos WHERE nest_id = id;

    INSERT INTO Mart(nest_id, link, image_path, bird_id, video_path, report)
        SELECT nest_id, null, null, null, null, observation AS report FROM DW_reports WHERE nest_id = id;

   END;
$$
LANGUAGE plpgsql;

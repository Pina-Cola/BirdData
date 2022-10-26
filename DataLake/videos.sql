DROP TABLE IF EXISTS videos;

CREATE TABLE videos (
    filepath VARCHAR(255) PRIMARY KEY,
    filename VARCHAR(255),
    nest_id VARCHAR(255)
);

DROP TABLE IF EXISTS images;

CREATE TABLE images (
    filepath VARCHAR(255) PRIMARY KEY,
    filename VARCHAR(255),
    date_time TIMESTAMP,
    latitude REAL,
    longitude REAL,
    maps_link VARCHAR(255)
);

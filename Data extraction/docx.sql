/* Drop tables*/
DROP TABLE IF EXISTS ringmarkning_2020_docx;
DROP TABLE IF EXISTS ringmarkning_2021_docx;
DROP TABLE IF EXISTS kartor_2021_docx;
DROP TABLE IF EXISTS kartor_2022_docx;
DROP TABLE IF EXISTS fejkrapport_docx;



/* Create table ringmärkning_2020_docx */
CREATE TABLE ringmarkning_2020_docx (
    ring_ID int PRIMARY KEY,
    species varchar(50),
    age varchar(50),
    place text,
    city varchar(50),
    date_time varchar(50),
    file_path text
);

/* Create table ringmärkning_2021_docx */
CREATE TABLE ringmarkning_2021_docx (
    ring_ID int PRIMARY KEY,
    species varchar(50),
    age varchar(50),
    place text,
    city varchar(50),
    date_time varchar(50),
    file_path text
);


/* Create table fejkrapport_docx*/
CREATE TABLE fejkrapport_docx (
    nest_ID varchar(50) PRIMARY KEY,
    description text
);

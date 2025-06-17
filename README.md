# BirdData – University Project

This repository contains the backend and database structure for the *BirdBundle* university project. 

This project follows a simplified data pipeline architecture:
- **Data extraction** → **Data lake** → **Data warehouse** → **Data mart**
- Backend and SQL scripts to manage and query structured bird data
- Support for frontend integration via APIs

## Repository Structure

| Folder / File               | Description                                 |
|----------------------------|---------------------------------------------|
| `Data/`                    | Raw bird observation and nesting data       |
| `Data extraction/`         | Scripts to ingest and clean raw data        |
| `DataLake/`                | Staging area for transformed data           |
| `DataWarehouse/`           | Structured tables (facts and dimensions)    |
| `DataMart/`                | Aggregated views for analysis               |
| `Backend/`                 | Python-based backend logic and endpoints    |
| `Database/`                | DB configuration and utilities              |
| `Frontend/`                | (Deprecated – see new repo below)           |
| `DataMart.sql`             | Script to build the data mart               |
| `create_data_warehouse.sql`| Script to build the data warehouse schema   |

## Frontend

The Angular frontend can be found in a separate repository:  
🔗 **[angular-bird-bundle](https://github.com/Pina-Cola/angular-bird-bundle)**

This frontend connects to the backend in this repository and visualizes the bird data.

## Technologies

- PostgreSQL / PLpgSQL
- Python (data processing, backend)
- Angular (frontend, separate repo)

## Project Context

This project was developed as part of a **university group project** focused on building a simplified data warehousing system for ecological bird data.


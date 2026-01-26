/* 
    Creating a database where i will be testing my data warehousing skills
*/
CREATE DATABASE IF NOT EXISTS wrhsetestDB;

/*
    creating tables that are 3NF
*/
CREATE TABLE IF NOT EXISTS projects_lead(
    lead_id SERIAL PRIMARY KEY,
    consultant_name VARCHAR(100) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    client_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS consultants(
    consultant_name VARCHAR(100) NOT NULL,
    consultant_email VARCHAR(100) NOT NULL,
    hourly_rate INTEGER NOT NULL,
    PRIMARY KEY(consultant_name, consultant_email)
);


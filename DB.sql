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

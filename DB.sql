/* 
    Creating a database where i will be testing my data warehousing skills
*/
CREATE DATABASE IF NOT EXISTS wrhsetestdb;


/*
    creating tables that are 3NF
*/
CREATE TABLE IF NOT EXISTS consultants(
    consultant_id SERIAL PRIMARY KEY,
    consultant_name VARCHAR(100) NOT NULL,
    consultant_email VARCHAR(100) NOT NULL,
    hourly_rate INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS clients(
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    client_hq_city VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS projects(
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    consultant_id INTEGER REFERENCES consultants(consultant_id),
    client_id INTEGER REFERENCES clients(client_id)
);

/*
    Creating indexes
*/
CREATE INDEX idx_consultant_id ON consultants(consultant_id);

CREATE INDEX idx_client_id ON clients(client_id);

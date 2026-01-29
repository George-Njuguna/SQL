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
     - Since primary keys are automatically indexed we therefore do not need to index them
     - We will therefore need to index the foreign keys since there will be joinings 
     - Also create composite keys on two columns that have unique values.
*/
CREATE INDEX idx_projects_consultant_id ON projects(consultant_id) ;
CREATE INDEX idx_projects_client_id ON projects(client_id) ;

/* 
    checking the explain 
*/
EXPLAIN
select * 
FROM projects a
JOIN consultants b ON a.consultant_id = b.consultant_id
WHERE a.consultant_id = 5000 ;

/* NOTE 
    - in creating composite index the column with the most unique values (cardinality) should come first in the brackets
        ie if you have columns like vendor_id , status and invoice_date since status is only paid , unpaid or pending it should come after vendor_id
            since you can have more than three vendors and after invoice dates since you can have more invoices . 
*/        
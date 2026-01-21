/* Designing a 1NF table*/
CREATE TABLE student_sports(
    /* unique identifier */
    entry_id SERIAL PRIMARY KEY ,
    /* Student id  Not unique since many students can play more than 1 sport */
    student_id INTEGER NOT NULL,
    /* Sport played*/
    sport VARCHAR (200) NOT NULL
)

/*
Loading the data in 1NF Format
Note we can load the same student id 
*/
INSERT INTO student_sports(student_id, sport)
VALUES
    (54 , 'Basketball'),
    (24 , 'Football'),
    (54 , 'Football'),
    (13 , 'Football'),
    (54 , 'Rugby');

/*
Making a 2NF table
 - it has to be 1NF 
 - columns shouldnt partially depend on primary key 
*/
CREATE  TABLE student_sports(
    entry_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    student_name VARCHAR(200) NOT NULL,
    sport VARCHAR(200) NOT NULL,
    coach VARCHAR(200) NOT NULL
)
/* From the above table the table is 1NF to change it to 2NF 
 - student_id does not depend on entry_id (PK) but depends on the student_id therfore we can remove the part that depends on students id 
 - coach doesnt depend on the entry id but depends on the sport we will also remove it and place it in a new table 
*/
CREATE TABLE student_sports(
    entry_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    sport VARCHAR(200) NOT NULL
)

CREATE TABLE students(
    student_id INTEGER NOT NULL PRIMARY KEY,
    student_name VARCHAR(200) NOT NULL
)

CREATE TABLE sports(
    sport VARCHAR(200) NOT NULL PRIMARY KEY,
    coach VARCHAR(200) NOT NULL
)
/* Now student_id and sport become FOREIGN KEYS that connect their respective tables to the student_sports table 
 Achieving 2NF
*/

/* Good schemas use composite keys */
CREATE TABLE student_sports(
    student_id INTEGER NOT NULL,
    sport VARCHAR(200) NOT NULL,
    
    PRIMARY KEY(student_id, sport)
);
/* This ensures no student can have a sport logged twice*/
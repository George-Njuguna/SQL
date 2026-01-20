/* Designing a 1NF table*/
CREATE TABLE sports(
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
INSERT INTO sports(student_id, sport)
VALUES
    (54 , 'Basketball'),
    (24 , 'Football'),
    (54 , 'Football'),
    (13 , 'Football'),
    (54 , 'Rugby');
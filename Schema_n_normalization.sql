/* Designing a 1NF table*/
CREATE TABLE student_sports(
    /* unique identifier */
    entry_id SERIAL PRIMARY KEY ,
    /* Student id  Not unique since many students can play more than 1 sport */
    student_id INTEGER NOT NULL,
    /* Sport played*/
    sport VARCHAR (200) NOT NULL
);

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
CREATE TABLE student_sports(
    student_id INTEGER NOT NULL,
    sport VARCHAR(200) NOT NULL,
    student_name VARCHAR(200) NOT NULL,
    coach_name VARCHAR(200) NOT NULL ,   
    PRIMARY KEY(student_id, sport)
);
/* 
The above table is a table that contains composite key(2 primary keys)
When a table only has one primary key it is already 2NF
when a table has a composite key here is when we check for 2NF
 From the above table the table is 1NF to change it to 2NF 
 - student_name does not wholy depend on the primary key it only depends  on the student_id therfore creating a partial dependancy we can remove the part that depends on students id 
 - coach doesnt depend wholly primary key it only depends on on  the sport we will also remove it and place it in a new table 
*/
CREATE TABLE student_sports(
    student_id INTEGER NOT NULL,
    sport VARCHAR(200) NOT NULL,
    PRIMARY KEY(student_id, sport) /* creating a composite key */
);
CREATE TABLE students(
    student_id INTEGER NOT NULL PRIMARY KEY,
    student_name VARCHAR(200) NOT NULL,
    student_email VARCHAR(200) NOT NULL
);

CREATE TABLE sports(
    sport VARCHAR(200) NOT NULL PRIMARY KEY,
    coach VARCHAR(200) NOT NULL
);
/* Now the table is 2NF since it wholy depends on the composite Key(primary_key)*/


/*
Making a 3NF table
 - it has to be 2NF 
 - columns shouldnt indirectly depend on the primary key (no non key column should depend on a non key column)
*/
CREATE  TABLE student_sports(
    entry_id SERIAL PRIMARY KEY
    student_id INTEGER NOT NULL PRIMARY KEY,
    student_name VARCHAR(200) NOT NULL,
    sport VARCHAR(200) NOT NULL,
    coach VARCHAR(200) NOT NULL
);
/* From the above table the table is 2NF since it has only one Pimary key removing the partial dependance 
 - student_id does not depend on entry_id (PK) but depends on the student_id therfore we can remove the part that depends on students id 
 - coach doesnt depend on the entry id but depends on the sport we will also remove it and place it in a new table 
*/
CREATE TABLE student_sports(
    entry_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    sport VARCHAR(200) NOT NULL
);

CREATE TABLE students(
    student_id INTEGER NOT NULL PRIMARY KEY,
    student_name VARCHAR(200) NOT NULL
);

CREATE TABLE sports(
    sport VARCHAR(200) NOT NULL PRIMARY KEY,
    coach VARCHAR(200) NOT NULL
);
/* Now student_id and sport become FOREIGN KEYS that connect their respective tables to the student_sports table 
 Achieving 3NF
*/

/* INDEXES */
/* Normaly postgres automatically creates indexes for you but if you want to create an index manually*/
CREATE INDEX idx_student_email 
ON students(email);
    /*The index name*/            /*(table)  (column)*/ 

/* To create a hash table which is 0(N)*/
CREATE INDEX idx_student_id_hash 
ON students 
USING HASH(student_id);

/* 
    Always use B-tree index instead of hash but only use Hsh index when :
        - The table contains alot of rows ie Millions of Rows 
        - You are 100% sure that you will never need to range search 
*/

/*
    COMPOSITE INDEXING
    We can index multiple columns together inorder to make a composite index
    This especially prevalent when choosing columns that come in pairs:
                                                                    first name - second name 
                                                                    city - state
    in queries that involve checking both first name and last name it is better to use a composite index since it is faster than 
    an index with only one column.
    note the leftmost rule which states that composite index of first name and second name helps in speeding up the query 
    where it filters by only first name but does not help the query that only filters by second name 
    In the leftmost rule the composite 
*/

CREATE INDEX idx_student_names
ON students(first_name, last_name);
/*
   NOTE 
    - in creating composite index the column with the most unique values (cardinality) should come first in the brackets
        ie if you have columns like vendor_id , status and invoice_date since status is only paid , unpaid or pending it should come after vendor_id
            since you can have more than three vendors and after invoice dates since you can have more invoices.
            
*/
CREATE INDEX composite_idx
ON vendors(vendor_id,invoice_date,statuss);

/*
    EXPLAIN and EXPLAIN ANALYZE
    - When you use explain and EXPLAIN ANALYZE in your query it shows you how the engine thinks and what is going on in the behind the scene
    - This is important when creating tables because when you notice a query taking alot of time to finish you can use EXPLAIN and 
      EXPLAIN Analyze to see what is happening and what path the engine is taking maybe its not using your indexes and maybe you forgot to add

    EXPLAIN  - When you use explain in your query it shows you how the engine will run the query.
             - Explain doesnt actually run the query it just analyzes 

    EXPLAIN ANALYZE - when you use EXPLAIN ANALYZE this actually runs and analyzes the run
                    - Therefore it is important to be carefull when using it with DELETE or UPDATE statements since it will run them.
    
    In your output you see seq scan this is bad this means that the query is checking every row therefore can be very slow when having table with millions of rows, Therefore you need to add indexes.
    The good one is index_scan which shows it is using a b_tree index 
    The best one is Index only scan The DB finds all the data it needs inside the index itself and never even touches the actual table
*/
EXPLAIN 
SELECT * 
FROM students
WHERE student_id = 101; /* This doesnt run the query it only analyzes */

EXPLAIN ANALYZE
SELECT * 
FROM students
WHERE student_id = 101; /* This runs and analyzes the query also giving the time spent */

/*
    TRANSACTIONS AND ISOLATION LEVELS
    TRANSACTIONS in Databases are important since it prevents data leackage ,and data that is not full ie partial data
        ie if a bank transaction crashes in during then you dont want cash removed from one account but not deposited into the next 
        Transactions should have ACID (Atomicity, Consistency, Isolation, Durability) prnciples.

    Good ISOLATION LEVELS are important since it helps to prevent Dirty Reads, Non Repeatable Reads and Phantom Reads.
    
    In Choosing Isolation Levels it is always better to look at the following
            read commited(Default)    - this is an isolation level where both parties looking at a database can make decisions on database
                                it is extremley fast but poses a problem when lets say a seat is booked twice since person A and B saw a seat that was not
                                booked, booked it at the same time then creating an overbooking 
                                Repeated reads are usually goods where speed is required and consistency is not a priority ie social media follower counts , likes 
                                since accuracy here is not really important

            The pessimistic approach(select for updates) - This is an isolation approach that locks the row and not the table lets say there are only 5 tickets left for
                                                            a concert, since these seats are on demand therefore when person A clicks on buy ticket then person B clicks 
                                                            on it, person B hangs untill person A finishes then when person B tries to buy i says ticket has been bought.
                                                            This is extremley safe.
                                                            You should only use this when 1. Contention is high - You know Multiple users are fighting for the same row
                                                                                          2. Granular Control - You want to lock only the row and not the whole table or range of data
                                                                                          3. Predictable logic - if your logic is Check Value -> Update Value -> Commit 
            
            Serializable (Optimistic Aproach) - if you choose this isolation approach the engine acts as a librarian that only allows people to pick one book at a time .You are not locking
                                                rows but you are telling the engine to run the transaction as if no one else exists.
                                                You should use the serializable approach when 
                                                                        1. There is complex dependancies - your Transaction involves alot of tables.
                                                                        2. Range Protection: You need to prevent Phantom Reads 
                                                                            (e.g., "Ensure the sum of all transactions for this day equals exactly $10,000").
                                                                            SELECT FOR UPDATE struggles with rows that don't exist yet; Serializable handles them.
                                                The difference between Select for Update and Serializable is that serializable lets people work and brings up an error when person B tries to commit 
                                                whereas Select for updates doesnt let person B work, person b just Lags.

NOTE:Key Takeaways for the Pipeline

Isolation levels are set on the connection ie in python , not the database itself.

Higher isolation = More Retries. If you use SERIALIZABLE, your script must be prepared to catch errors and try again.

Performance: If your Python app is slow, check if you've set a high isolation level globally by mistake—this causes "Lock Wait" timeouts.

*/   

/*
    STAGING + COPY
    In Loading data, loading from RAW to Production is not ideal because of these reasons 
                - while loading millions of rows then one cell has a mismatch o data types then you have an error and lets say 15 minutes of loading leaves you with dirty data.
                - lets say you have an index(b-Tree index) when loading the data CPU processing power will spike due to the engine needing to re-index
    It is therefore wise to use STAGING before loading data to production. 
*/

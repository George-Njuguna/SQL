-- This project is where i try to rebuild my existing spotify database using what i have learnt 

CREATE DATABASE spotify_wrhse;

/* 
    In my databse there are different tables nameley :
                 followed_artists       
                 genre                  
                 playlist_tracks        
                 playlists              
                 recently_played_tracks 
                 saved_albums           
                 saved_tracks           
                 top_artists            
                 top_tracks 

    Where these tables do not follow the DataBase Design Principles.
    I will therefore start with recently_played_tracks
*/

/*                  recently_played_tracks
    when we check the table structure of this table we get
                    Table "public.recently_played_tracks"
        Column      |           Type           | Collation | Nullable | Default
        ------------+--------------------------+-----------+----------+---------
        played_at   | timestamp with time zone |           | not null |
        id          | text                     |           |          |
        name        | text                     |           | not null |
        artist_name | text                     |           | not null |
        artist_id   | text                     |           |          |
        album_name  | text                     |           | not null |
        album_id    | text                     |           |          |
        duration    | integer                  |           |          |
        explicit    | boolean                  |           |          | true
        popularity  | integer                  |           |          |
        Indexes:
            "recently_played_tracks_pkey" PRIMARY KEY, btree (played_at)
    
    NORMAL FORMS
    The table is already 1NF since all the columns have atomic content(indivisible) 

    2NF : This is to remove redundancy in the table but since the table has 1 primary key the table already is in 2NF 
          BUT we can change the primary Key to a number which is faster in lookups and Joins therefore "entry_id will be BIGSERIAL PRIMARY KEY"
          We will also need to create a tracks table where information about a song is listed inorder not to repeat artist_id, artist_name,album_id, album_name more and more times 

    3NF : The table is not 3NF since some columns do not soley depend on the primary key directly therfore that part of the table needs to be taken to another table
          album_name directly depend on the album_id and not the primary key therefore we will create an albumns_table 
          artist_name directly depend on the artist_id and not the primary key therefore we will create an artists_table 
          we will also remove the explicit column since it doesnt give new information.
*/

-- Note we will first create the tables without the foreign keys the tables are artist played since it doest have a foreign key  
-- artist table
CREATE TABLE IF NOT EXISTS artists(
    artist_id VARCHAR(22) PRIMARY KEY,
    artist_name TEXT,
    genre TEXT
);

-- We will then create the albums table since it only references the artist table 
-- album table
CREATE TABLE IF NOT EXISTS played_albumns(
    album_id VARCHAR(22) PRIMARY KEY,
    album_name TEXT
    artist_id VARCHAR(22) REFERENCES artist(artist_id)
);

-- We will now create a tracks table since it references the album and artist table 
-- CREATING tracks table 
CREATE TABLE IF NOT EXISTS tracks(
    track_id VARCHAR(22) PRIMARY KEY,
    track_name TEXT,
    artist_id VARCHAR(22) REFERENCES artists(artist_id),
    album_id VARCHAR(22) REFERENCES albuma(album_id),
    popularity INTEGER
);

-- We will now create the songs played 
-- CREATING songs played table 
CREATE TABLE IF NOT EXISTS tracks_played(
    entry_id BIGSERIAL PRIMARY KEY,
    track_id VARCHAR(22) REFERENCES tracks(track_id),
    played_at TIMESTAMPTZ
);
/* Now that the tables have been created when loading the data you have to load the data in this order 
   artist -> albums -> tracks -> tracks_played
*/

--  INDEXING
/*  I will now index columns which will be usefull when searching 
    Primary keys are usually indexed by the engine but things like foreign keys are not therefore we will index the foreign keys 
    These indexes will be important especially when joining tables to make queries more fast.
*/
--  indexing the artist_id(FK) in albums table 
CREATE INDEX idx_albums_artist_id on albums(artist_id);

-- indexing artist id and album id in tracks Table
CREATE INDEX idx_tracks_artist_id on tracks(artist_id);
CREATE INDEX idx_tracks_album_id on tracks(album_id);

-- indexing track_id in tracks_played
CREATE INDEX idx_tracks_played_id on tracks_played(track_id);

/*              followed artists
    We will now create a followed artist table 
    This table contains artists that the user follows 

    when checking the table
            Table "public.followed_artists"
        Column   |  Type   | Collation | Nullable | Default
     ------------+---------+-----------+----------+---------
        id         | text    |           | not null |
        name       | text    |           | not null |
        popularity | integer |           |          |
        followers  | integer |           |          |
        genre      | text    |           | not null |
        Indexes:
            "followed_artists_pkey" PRIMARY KEY, btree (id)

    From the table structure we can see the table has 5 columns and the id(artist_id) is the PK 
    The Table is already 1NF and 2NF therefore we need to change it to 3NF
    We will remove popularity and Followers from the table since it doesnt have any use in our final report
*/

CREATE TABLE IF NOT EXISTS followed_artists(
    artist_id VARCHAR(22) PRIMARY KEY,
    name TEXT NOT NULL,
    genre TEXT NOT NULL
)

/*  We will now check the playlist table 
                Table "public.playlists"
        Column  |  Type   | Collation | Nullable | Default
        ----------+---------+-----------+----------+---------
        id       | text    |           | not null |
        name     | text    |           | not null |
        owner_id | text    |           | not null |
        tracks   | integer |           |          |
        public   | boolean |           |          | true
        Indexes:
            "playlists_pkey" PRIMARY KEY, btree (id)
    
    The table is already 3NF but we can remove the public column 
*/
CREATE TABLE IF NOT EXISTS playlists(
    playlist_id VARCHAR(22) PRIMARY KEY,
    Playlist_name TEXT,
    owner_id VARCHAR(22),
    tracks INTEGER
)

/* we will now check for the saved_albums
                    Table "public.saved_albums"
        Column    |  Type   | Collation | Nullable | Default
        -------------+---------+-----------+----------+---------
        id          | text    |           | not null |
        name        | text    |           | not null |
        artist_name | text    |           | not null |
        artist_id   | text    |           |          |
        tracks      | integer |           |          |
        popularity  | integer |           |          |
        Indexes:
            "saved_albums_pkey" PRIMARY KEY, btree (id)

    To change this to 3NF we need to remove the artist name 
    Then we will remove popularity from the table 
*/
CREATE TABLE saved_albums(
    album_id VARCHAR(22) PRIMARY KEY,
    album_name TEXT,
    artist_id VARCHAR(22) REFERENCES artists(artist_id), /* For an album to be saved it means it has already been listened */
    total_tracks INTEGER
)





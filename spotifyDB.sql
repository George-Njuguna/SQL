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
        Column    |           Type           | Collation | Nullable | Default
        -------------+--------------------------+-----------+----------+---------
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
    The table is not in 1NF since the primary Key (played at) can be divided into two data timestamp and timezone therfore we need
    to change it to only show the time 

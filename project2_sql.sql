-- Drop and create table
DROP TABLE IF EXISTS spotify;

CREATE TABLE spotify (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(255),
    Danceability FLOAT,   
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,  
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views FLOAT,
    Likes BIGINT,
    Comments BIGINT,
    Licensed BOOLEAN,
    official_video BOOLEAN,
    Stream BIGINT,
    Energy_Liveness FLOAT,
    Most_played VARCHAR(50)
);

-- COPY statement
COPY spotify(
    Artist, Track, Album, Album_type, Danceability, Energy, Loudness, Speechiness,
    Acousticness, Instrumentalness, Liveness, Valence, Tempo, Duration_min,
    Title, Channel, Views, Likes, Comments, Licensed, official_video, Stream,
    Energy_Liveness, Most_played
)
FROM 'E:/Downloads/cleaned_dataset.csv'
DELIMITER ','
CSV HEADER
QUOTE '"';

SELECT COUNT (DISTINCT album)FROM spotify;
SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min=0;

DELETE FROM spotify
WHERE duration_min=0;
SELECT * FROM spotify
WHERE duration_min=0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT Most_played FROM spotify;

--Queries from easy category
--1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE stream >1000000000;

--2.List all albums along with their respective artists

SELECT
  DISTINCT album,artist
  FROM spotify
  ORDER BY 1;
  
--3.Get the total number of comments for tracks where licensed = TRUE.
--SELECT DISTINCT licensed FROM spotify
SELECT
SUM(comments) AS total_comments
FROM spotify
WHERE licensed ='true';

--4.Find all tracks that belong to the album type single.

SELECT * FROM spotify 
WHERE album_type ='single';


--.5Count the total number of tracks by each artist.
SELECT artist,
COUNT(*) AS total_no_songs
FROM spotify
GROUP BY artist;
------------------------------------------------------------------------------

--intermediate 
--6.Calculate the average danceability of tracks in each album.
SELECT * FROM spotify ;
SELECT AVG(danceability) AS avg_danceability 
FROM spotify;

--7.Find the top 5 tracks with the highest energy values.
SELECT 
track,
AVG(energy)
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--8.List all tracks along with their views and likes where official_video = TRUE.
SELECT
track,
SUM(views) AS total_views,
SUM(likes) AS total_views
FROM spotify
WHERE official_video='true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9.For each album, calculate the total views of all associated tracks.

SELECT
ALBUM,
TRACK,
SUM(views)
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

--10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT
track,
COALESCE(SUM(CASE WHEN  Most_played='YOUTUBE' THEN stream END),0) AS streamed_on_youtube,
COALESCE(SUM(CASE WHEN  Most_played='Spotify' THEN stream END),0) as streamed_on_spotify
 FROM spotify
 GROUP BY 1
 ) AS t1 
 WHERE 
 streamed_on_spotify  > streamed_on_youtube
 AND
 streamed_on_youtube <> 0;


----------------------------------------------------------------------------------
--advanced problems 
--11.Find the top 3 most-viewed tracks for each artist using window functions.
--Each artist and total view for each track
--track with highest view 
--dense rank
--cte and filder rank < =3
WITH ranking_artist
AS
(SELECT
artist,track,
SUM(VIEWS) as total_view,
DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM (views) DESC) AS RANK
FROM spotify 
GROUP BY 1,2 
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank  <=3;

--12.Write a query to find tracks where the liveness score is above the average.
SELECT 
track,
artist,
liveness
FROM spotify
WHERE liveness > (SELECT AVG(LIVENESS) FROM SPOTIFY);


--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC






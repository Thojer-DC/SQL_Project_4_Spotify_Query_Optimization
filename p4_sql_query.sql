-- Creating Database

CREATE DATABASE p4_spotify;

-- Creating spotify table

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify
(
	Artist VARCHAR(255),
	Track VARCHAR(255),
	Album VARCHAR(255),
	Album_type VARCHAR(50),
	Danceability FLOAT,
	Energy FLOAT,
	Loudness FLOAT,
	Speechiness FLOAT,
	Acousticness FLOAT,
	Instrumentalness FLOAT,
	Liveness FLOAT,
	Valence	 FLOAT,
	Tempo FLOAT,
	Duration_min FLOAT,
	Title VARCHAR(255),
	Channel VARCHAR(255),
	Views BIGINT,
	Likes BIGINT,
	Comments BIGINT,
	Licensed BOOLEAN,
	official_video BOOLEAN,
	Stream FLOAT,
	EnergyLiveness	FLOAT,
	most_playedon VARCHAR(50)
);

SELECT * FROM spotify;


-- EDA

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;
SELECT * FROM spotify
WHERE duration_min = 0;

SELECT COUNT(DISTINCT channel) FROM spotify;

SELECT DISTINCT most_playedon FROM spotify;





-- Questions

-- Easy Level
-- 1. Retrieve the names of all tracks that have more than 2.5 billion streams.
SELECT * FROM spotify
WHERE stream > 2500000000;

-- 2. List all albums along with their respective artists.
SELECT 
	DISTINCT album,
	artist
FROM spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT 
	SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'TRUE';

-- 4. Find all tracks that belong to the album type single.
SELECT *
FROM spotify
WHERE album_type = 'single';

-- 5. Count the total number of tracks by each artist.
SELECT 
	artist,
	COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist;

-- Medium Level
-- 1. Calculate the average danceability of tracks in each album.
SELECT
	album_type,
	AVG(danceability) AS average_danceability
FROM spotify
GROUP BY album_type;

-- 2. Find the top 5 tracks with the highest energy values.
SELECT 
	*
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 3. List all tracks along with their views and likes where official_video = TRUE.
SELECT 
	track,
	views,
	likes
FROM spotify
WHERE official_video = 'TRUE';


-- 4. For each album, calculate the total views of all associated tracks.
SELECT
	album,
	SUM(views) AS total_views
FROM spotify
GROUP BY album;


-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT 
	*
FROM
(
SELECT
	track,
	SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END) AS total_stream_spotify,
	SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END) AS total_stream_youtube
FROM spotify
GROUP BY 1
)
WHERE 
	total_stream_spotify > total_stream_youtube
	AND
	(total_stream_youtube IS NOT NUll AND total_stream_youtube <> 0);


-- Advanced Level
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT 
	*
FROM
(
	SELECT
		artist,
		track,
		views,
		RANK() OVER(PARTITION BY artist ORDER BY views DESC) AS rank
	FROM spotify

)
WHERE rank <=3 ;


-- 2. Write a query to find tracks where the liveness score is above the average.
SELECT
	*
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);


-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH t_table
AS
(
SELECT 
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)

SELECT 
	album,
	highest_energy - lowest_energy AS diff_energy
FROM t_table
ORDER BY 2 DESC;


-- 4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT 
	*
FROM spotify
WHERE (energy / liveness) > 1.2;


-- 5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT
	*
FROM
(
	SELECT
		track,
		SUM(views) AS total_views,
		SUM(likes) AS total_likes
	FROM spotify
	GROUP BY 1
)
ORDER BY total_views DESC;


-- Query Optimization

EXPLAIN ANALYZE
SELECT
	artist,
	track,
	views
FROM spotify
WHERE 
	artist = 'Ed Sheeran'
	AND
	most_playedon = 'Spotify'
ORDER BY stream DESC
LIMIT 5;


CREATE INDEX idx_artist ON spotify(artist);

EXPLAIN ANALYZE
SELECT
	artist,
	track,
	views
FROM spotify
WHERE 
	artist = 'Ed Sheeran'
	AND
	most_playedon = 'Spotify'
ORDER BY stream DESC
LIMIT 5;
















# Spotify Advanced SQL Project and Query Optimization
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/spotify.png)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level

1. Retrieve the names of all tracks that have more than 2.5 billion streams.
```sql
SELECT * FROM spotify
WHERE stream > 2500000000;
```

2. List all albums along with their respective artists.
```sql
SELECT 
	DISTINCT album,
	artist
FROM spotify;
```

3. Get the total number of comments for tracks where licensed = TRUE.
```sql
SELECT 
	SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'TRUE';
```

4. Find all tracks that belong to the album type single.
```sql
SELECT *
FROM spotify
WHERE album_type = 'single';
```

5. Count the total number of tracks by each artist.
```sql
SELECT 
	artist,
	COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
SELECT
	album_type,
	AVG(danceability) AS average_danceability
FROM spotify
GROUP BY album_type;
```

2. Find the top 5 tracks with the highest energy values.
```sql
SELECT 
	*
FROM spotify
ORDER BY energy DESC
LIMIT 5;
```

3. List all tracks along with their views and likes where official_video = TRUE.
```sql
SELECT 
	track,
	views,
	likes
FROM spotify
WHERE official_video = 'TRUE';
```

4. For each album, calculate the total views of all associated tracks.
```sql
SELECT
	album,
	SUM(views) AS total_views
FROM spotify
GROUP BY album;
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
```


### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```



2. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT
	*
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```



3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
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
```



4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
SELECT 
	*
FROM spotify
WHERE (energy / liveness) > 1.2;
```



5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
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
```



Here’s an updated section for your **Spotify Advanced SQL Project and Query Optimization** README, focusing on the query optimization task you performed. You can include the specific screenshots and graphs as described.

---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **8.3 ms**
        - Planning time (P.T.): **0.13 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss1.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.109 ms**
        - Planning time (P.T.): **0.213 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss2.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
    - Analysis:
      ![Performance Analysis](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss1.1.png)
      ![Performance Analysis](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss2.1.png)
    - Graphical:
      ![Performance Graph](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss1.2.png)
      ![Performance Graph](https://github.com/Thojer-DC/SQL_Project_4_Spotify_Query_Optimization/blob/main/ss2.2.png)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---

## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

---

## License
This project is licensed under the MIT License.

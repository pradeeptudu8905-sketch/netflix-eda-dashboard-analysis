use netflix;
-- KPI 1: Content Growth Rate
WITH yearly_counts AS (
    SELECT 
        YEAR(date_added) AS year_added,
        COUNT(*) AS total_titles
    FROM netflix_data
    WHERE date_added IS NOT NULL
    GROUP BY year_added
)
SELECT 
    year_added,
    total_titles,
    ROUND(
        (total_titles - LAG(total_titles) OVER (ORDER BY year_added)) * 100.0 /
        LAG(total_titles) OVER (ORDER BY year_added),
        2
    ) AS growth_rate_percent
FROM yearly_counts;

-- KPI 2: Movie-to-Show Ratio
SELECT 
    ROUND(
        SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) /
        SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END),
        2
    ) AS movie_to_tv_ratio
FROM netflix_data;


-- KPI 3: Content Freshness Score
SELECT 
    ROUND(
        AVG(YEAR(date_added) - release_year),
        2
    ) AS freshness_score
FROM netflix_data
WHERE date_added IS NOT NULL
  AND YEAR(date_added) >= release_year;
  
  
  -- KPI 4: Mature Content Share
SELECT 
    ROUND(
        COUNT(CASE WHEN rating IN ('TV-MA', 'R') THEN 1 END) * 100.0 /
        COUNT(*),
        2
    ) AS mature_content_percentage
FROM netflix_data;


-- KPI 5: Genre Diversity Index
SELECT 
    COUNT(DISTINCT genre) * 1.0 / COUNT(*) AS genre_diversity_index
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre
    FROM netflix_data
    JOIN (
        SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
        SELECT 4 UNION ALL SELECT 5
    ) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
) AS genres;
-- Top countries producing Netflix content
SELECT 
    country,
    COUNT(*) AS total_titles
FROM netflix_data
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;

-- Yearly content addition trend
SELECT 
    YEAR(date_added) AS year_added,
    COUNT(*) AS total_titles
FROM netflix_data
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


-- Top genres
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre,
    COUNT(*) AS total
FROM netflix_data
JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
    SELECT 4 UNION ALL SELECT 5
) numbers
ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
GROUP BY genre
ORDER BY total DESC
LIMIT 10;


-- Average movie duration
SELECT 
    ROUND(AVG(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)), 2) AS avg_duration_minutes
FROM netflix_data
WHERE type = 'Movie';

-- Trend of Movies vs TV Shows
SELECT 
    YEAR(date_added) AS year_added,
    type,
    COUNT(*) AS total
FROM netflix_data
WHERE date_added IS NOT NULL
GROUP BY year_added, type
ORDER BY year_added;

-- Top directors
SELECT 
    director,
    COUNT(*) AS total_titles
FROM netflix_data
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;

-- Month-wise content addition
SELECT 
    MONTHNAME(date_added) AS month_name,
    COUNT(*) AS total_titles
FROM netflix_data
WHERE date_added IS NOT NULL
GROUP BY month_name
ORDER BY total_titles DESC;

-- Content rating distribution
SELECT 
    rating,
    COUNT(*) AS total_titles
FROM netflix_data
GROUP BY rating
ORDER BY total_titles DESC;
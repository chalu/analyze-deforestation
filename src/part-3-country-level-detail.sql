-- 3.a.i Which top 2 countries have the largest amount of increase in forest area from 1990 to 2016?
-- What was the difference in the forest area for each?
-- China (East Asia & Pacific) - Diff:  527229.06
-- United States (North America) - Diff: 79200.00
WITH t1 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_1990
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 1990
),
t2 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_2016
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 2016
)
SELECT t1.country,
       t1.region,
       round((t2.forest_area_2016 - t1.forest_area_1990)::Decimal, 2) AS increase
FROM t1
JOIN t2 ON t1.country = t2.country
GROUP BY t1.country, t1.region, t2.forest_area_2016, t1.forest_area_1990
HAVING (t2.forest_area_2016 - t1.forest_area_1990) >= 0
ORDER BY increase DESC
LIMIT 2;


-- 3.a.ii Which country had the highest percent of forest area increase between 1990 to 2016
-- Iceland (Europe & Central Asia) increased by 213.66%
-- She went from 161.0000038 in 1990 to 505 in 2016
--
-- Next was French Polynesia (East Asia & Pacific), increasing by 181.82% from 550 to 1550
WITH t1 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_1990
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 1990
),
t2 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_2016
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 2016
)
SELECT t1.country,
       t1.region,
       round(
         (
           ((t2.forest_area_2016 - t1.forest_area_1990) / t1.forest_area_1990) * 100
         )::Decimal,
         2
       ) AS pct_increase
FROM t1
JOIN t2 ON t1.country = t2.country
GROUP BY t1.country, t1.region, t2.forest_area_2016, t1.forest_area_1990
HAVING (t2.forest_area_2016 - t1.forest_area_1990) >= 0
ORDER BY pct_increase DESC
LIMIT 2;

-- 3.b.i Which 5 countries saw the largest amount of decrease in forest area from 1990 to 2016? 
-- What was the difference in forest area for each?
-- Brazil - Diff: 541510.00
-- Indonesia - Diff: 282193.98
-- Myanmar - Diff: 107234.00
-- Nigeria - Diff: 106506.00
-- Tanzania - Diff: 102320.00
WITH t1 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_1990
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 1990
),
t2 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_2016
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 2016
)
SELECT t1.country,
        t1.region,
       --t1.forest_area_1990,
       --t2.forest_area_2016,
       round((t1.forest_area_1990 - t2.forest_area_2016)::Decimal, 2) AS decrease
FROM t1
JOIN t2 ON t1.country = t2.country
WHERE t1.country != 'World'
GROUP BY t1.country, t1.region, t1.forest_area_1990, t2.forest_area_2016
HAVING (t1.forest_area_1990 - t2.forest_area_2016) >= 0
ORDER BY decrease DESC
LIMIT 5;


-- 3.b.ii Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? 
-- What was the percent change to 2 decimal places for each?
-- Togo 75.45%
-- Nigeria 61.80%
-- Uganda 59.13%
-- Mauritania 46.75%
-- Honduras 45.03%
WITH t1 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_1990
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 1990
),
t2 AS (
  SELECT f.country_name AS country,
         r.region,
         f.forest_area_sqkm AS forest_area_2016
  FROM forest_area f
  JOIN regions r ON r.country_name = f.country_name
  WHERE year = 2016
)
SELECT t1.country,
       t1.region,
       --t1.forest_area_1990,
       --t2.forest_area_2016,
       round(
         (
           ((t1.forest_area_1990 - t2.forest_area_2016) / t1.forest_area_1990) * 100
         )::Decimal,
         2
       ) AS pct_decrease
FROM t1
JOIN t2 ON t1.country = t2.country
GROUP BY t1.country, t1.region, t1.forest_area_1990, t2.forest_area_2016
HAVING (t1.forest_area_1990 - t2.forest_area_2016) >= 0
ORDER BY pct_decrease DESC
LIMIT 5;


-- 3.c.i If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
-- At 52 countries, the 1st quartile has the most countries based on % forestation in 2016
WITH t1 AS (
  SELECT country,
         pct_forest,
         NTILE(4) OVER (ORDER BY pct_forest) AS quartile
  FROM (
    SELECT fa.country_name AS country,
           (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 AS pct_forest
    FROM land_area la
    JOIN forest_area fa
         ON la.country_code = fa.country_code
         AND la.year = fa.year
    WHERE la.year = 2016
  ) t2
  WHERE pct_forest > 0
)
    
SELECT quartile,
       COUNT(quartile) AS countries
FROM t1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- 3.c.ii List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
-- There were 51 countries
WITH t1 AS (
  SELECT country,
         region,
         pct_forest,
         NTILE(4) OVER (ORDER BY pct_forest) AS quartile
  FROM (
    SELECT fa.country_name AS country,
           rg.region,
           (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 AS pct_forest
    FROM land_area la
    JOIN forest_area fa
         ON la.country_code = fa.country_code
         AND la.year = fa.year
    JOIN regions rg
       ON fa.country_code = rg.country_code
    WHERE la.year = 2016
  ) t2
  WHERE pct_forest > 0
)
    
SELECT country,
       region,
       round(pct_forest::Decimal, 2) pct_forest
FROM t1
WHERE quartile >= 4
ORDER BY 3 DESC;


-- 3.d  How many countries had a percent forestation higher than the United States in 2016?
WITH t1 AS (
  SELECT (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 AS us_pct_forest
  FROM land_area la
  JOIN forest_area fa
       ON la.country_code = fa.country_code
       AND la.year = fa.year
  JOIN regions rg
       ON fa.country_code = rg.country_code
  WHERE la.year = 2016 AND fa.country_name = 'United States'
)
SELECT rg.country_name AS country,
       (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 AS pct_forest
FROM land_area la
JOIN forest_area fa
     ON la.country_code = fa.country_code
     AND la.year = fa.year
JOIN regions rg
     ON fa.country_code = rg.country_code
WHERE la.year = 2016
GROUP BY rg.country_name, fa.forest_area_sqkm, la.total_area_sq_mi
HAVING (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100 > (SELECT * FROM t1)
ORDER BY pct_forest DESC;

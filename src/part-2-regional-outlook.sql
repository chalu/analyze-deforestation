-- 2.a A table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016.
-- Note: 1 sq mi = 2.59 sq km
DROP TABLE IF EXISTS regions_forest;
CREATE TABLE regions_forest AS (
  SELECT rg.region,
         la.year,
         round(
           (
             (SUM(fa.forest_area_sqkm) / SUM(la.total_area_sq_mi * 2.59)) * 100
           )::Decimal,
           2
         ) AS pct_forest_area
  FROM land_area la
  JOIN forest_area fa
       ON la.country_code = fa.country_code
       AND la.year = fa.year
  JOIN regions rg
       ON fa.country_code = rg.country_code
  WHERE fa.year = 1990 OR fa.year = 2016
  GROUP BY 1, 2
);

-- 2.a.i - What was the percent forest of the entire world in 2016?
SELECT *
FROM regions_forest
WHERE region = 'World' AND year = 2016;


-- 2.a.ii - Which region had the HIGHEST percent forest in 2016?
-- Latin America & Caribbean => 46.16%
SELECT *
FROM regions_forest
WHERE year = 2016
ORDER BY pct_forest_area DESC
LIMIT 1;

-- 2.b.i - What was the percent forest of the entire world in 1990?
--  32.42%
SELECT *
FROM regions_forest
WHERE region = 'World' AND year = 1990;

-- 2.b.ii - Which region had the HIGHEST percent forest in 1990?
-- Latin America & Caribbean => 46.16%
SELECT *
FROM regions_forest
WHERE year = 1990
ORDER BY pct_forest_area DESC
LIMIT 1;

-- 2.b.iii - Which region had the LOWEST percent forest in 1990?
-- Middle East & North Africa => 1.78%
SELECT *
FROM regions_forest
WHERE year = 1990
ORDER BY pct_forest_area ASC
LIMIT 1;

-- 2.c - Which regions of the world DECREASED in forest area from 1990 to 2016?
-- Latin America & Caribbean & Sub-Saharan Africa
WITH t1 AS (
  SELECT region,
         pct_forest_area
  FROM regions_forest
  WHERE year = 1990
  ORDER BY region
),
t2 AS (
  SELECT region,
         pct_forest_area
  FROM regions_forest
  WHERE year = 2016
  ORDER BY region
)
SELECT t1.region,
       t1.pct_forest_area from_pct_forest_area,
       t2.pct_forest_area to_pct_forest_area,
       CASE WHEN t1.pct_forest_area > t2.pct_forest_area 
            THEN 'decreased'
            ELSE 'increased' END AS change
FROM t1
JOIN t2 ON t1.region = t2.region;

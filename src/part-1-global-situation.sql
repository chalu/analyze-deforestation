-- 1.a What was the total forest area (in sq km) of the world in 1990?
-- 41282694.90
SELECT round(forest_area_sqkm::numeric, 2) AS forest_area_sqkm
FROM forestation
WHERE code = 'WLD' AND year = 1990;

-- 1.b - What was the total forest area (in sq km) of the world in 2016?
-- 39958245.90
SELECT round(forest_area_sqkm::numeric, 2) AS forest_area_sqkm
FROM forestation
WHERE code = 'WLD' AND year = 2016;

-- 1.c - What was the change (in sq km) in the forest area of the world from 1990 to 2016?
-- 1324449.00
WITH t1 AS (
  SELECT code,
         round(forest_area_sqkm::numeric, 2) AS wld_forest_area_1990
  FROM forestation
  WHERE code = 'WLD' AND year = 1990
),
t2 AS (
  SELECT code,
         round(forest_area_sqkm::numeric, 2) AS wld_forest_area_2016
  FROM forestation
  WHERE code = 'WLD' AND year = 2016
)
SELECT wld_forest_area_1990, 
       wld_forest_area_2016,
       abs(wld_forest_area_1990 - wld_forest_area_2016) AS diff_1990_2016
FROM t1
JOIN t2 ON t1.code = t2.code;

-- 1.d - What was the percent change in forest area of the world between 1990 and 2016?
-- 3.21%
WITH t1 AS (
  SELECT code,
         round(forest_area_sqkm::numeric, 2) AS wld_forest_area_1990
  FROM forestation
  WHERE code = 'WLD' AND year = 1990
),
t2 AS (
  SELECT code,
         round(forest_area_sqkm::numeric, 2) AS wld_forest_area_2016
  FROM forestation
  WHERE code = 'WLD' AND year = 2016
)
SELECT wld_forest_area_1990, 
       wld_forest_area_2016,
       abs(wld_forest_area_1990 - wld_forest_area_2016) AS change,
       round(
         (
           (abs(wld_forest_area_1990 - wld_forest_area_2016) / wld_forest_area_1990) * 100
         )::numeric,
         2
       ) AS pct_change
FROM t1
JOIN t2 ON t1.code = t2.code;

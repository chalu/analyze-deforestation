DROP VIEW IF EXISTS "forestation";

CREATE OR REPLACE VIEW forestation AS (
  SELECT rg.country_name AS country,
         rg.country_code AS code,
         rg.region,
         rg.income_group AS income,
         la.year,
         la.total_area_sq_mi * 2.59 AS total_area_sqkm,
         fa.forest_area_sqkm,
         round(
           (
             (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) * 100
           )::Decimal,
           2
         ) AS pct_forest
  FROM land_area la
  JOIN forest_area fa
       ON la.country_code = fa.country_code
       AND la.year = fa.year
  JOIN regions rg
       ON fa.country_code = rg.country_code
);
           
SELECT * FROM forestation
ORDER BY year ASC;

-- country, code, region, income, year, total_area_sqkm, forest_area_sqkm, pct_forest => 5886 rows

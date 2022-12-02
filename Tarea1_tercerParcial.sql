--EJERCICIO #1--
select 
  SUM(number) over(partition by name,gender order by number desc ) as SUMA,
  name,
  gender
 from bigquery-public-data.usa_names.usa_1910_2013

 --EJERCICIO #2--
 select
  date,
  state,
  tests_total,
  cases_positive_total,
  SUM(tests_total) over(partition by state) as SUMA_TOTAL 
from bigquery-public-data.covid19_covidtracking.summary

--EJERCICIO #3--
WITH GJMA AS(
  select
    channelGrouping,
    date,
    totals.pageviews as TOTAL,
    SUM(totals.pageviews) over (partition by channelGrouping)as Pageviews2,
    row_number() over (partition by channelGrouping order by channelGrouping asc ) as rankk
  from bigquery-public-data.google_analytics_sample.ga_sessions_20170801
)
  select
    channelGrouping,
    Pageviews2,
    (Pageviews2/(sum(Pageviews2) over())) as Porcentaje,
    avg(Pageviews2) over()as Promedio,
  from GJMA where rankk=1 order by Pageviews2 desc

--EJERCICIO #4--
WITH GJMA3 AS(
SELECT 
 REGION,
 COUNTRY,
 Total_Revenue
FROM `tarea1lllparcial.SALES_RECORD.100SALES_RECORD` LIMIT 1000 
)SELECT
  REGION,
  COUNTRY,
  Total_Revenue,
  DENSE_RANK() OVER(PARTITION BY REGION ORDER BY Total_Revenue DESC) 
  FROM GJMA3 ORDER BY REGION





SELECT * FROM layoffs_final;

SELECT MAX(total_laid_off),MAX(percentage_laid_off) FROM layoffs_final;

SELECT SUBSTRING(`date`,1,7) as month_sub,
SUM(total_laid_off) OVER () as Running_Total
FROM layoffs_final
GROUP BY month_sub
#HAVING month_sub IS NOT NULL
#ORDER BY month_sub

;
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;


SELECT SUBSTRING(`date`,1,7) as d,
SUM(total_laid_off) as total_laid_off
FROM layoffs_final
GROUP BY d
HAVING d IS NOT NULL
ORDER BY d asc
;

SELECT SUBSTRING(`date`,1,7) as dates,
SUM(total_laid_off) as total_laid_off
FROM layoffs_final
GROUP BY dates
HAVING dates IS NOT NULL
ORDER BY dates asc;



WITH Monthly_Rolling_laid_Off AS
(SELECT SUBSTRING(`date`,1,7) as dates,
SUM(total_laid_off) as total_laid_off
FROM layoffs_final
GROUP BY dates
HAVING dates IS NOT NULL
ORDER BY dates asc
)
SELECT dates,SUM(total_laid_off) OVER (ORDER BY dates) AS Rolling_Total
FROM Monthly_Rolling_laid_Off
;

SELECT 
  dates,
  SUM(total_laid_off) OVER (ORDER BY dates) AS Rolling_Total
FROM (
  SELECT SUBSTRING(`date`, 1, 7) AS dates,
         SUM(total_laid_off) AS total_laid_off
  FROM layoffs_final
  GROUP BY dates
  HAVING dates IS NOT NULL
  ORDER BY dates
) AS Monthly_Rolling;


-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year.


SELECT company,
YEAR(`date`) as years,
SUM(total_laid_off) as SUM
FROM layoffs_final
GROUP by company,years
HAVING SUM IS NOT NULL
ORDER BY years
;

SELECT company,
YEAR(`date`) as years,
SUM(total_laid_off) as SUM
FROM layoffs_final
GROUP BY company,years
ORDER BY company;

WITH company_year AS
(
SELECT company, 
YEAR(`date`) as years,
SUM(total_laid_off) as laid_off,
dense_rank() OVER (PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) desc)
FROM layoffs_final
GROUP BY company,years
#ORDER BY years
)
SELECT company, 
YEAR(`date`) as years,
SUM(total_laid_off) as laid_off,
dense_rank() OVER (PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off))
FROM layoffs_final
GROUP BY company,years
HAVING laid_off IS NOT NULL
AND years IS NOT NULL

;

SELECT company, 
YEAR(`date`) as years,
SUM(total_laid_off) as laid_off,
dense_rank() OVER (PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off)) as ranking
FROM layoffs_final
GROUP BY company,years
HAVING laid_off IS NOT NULL
AND years IS NOT NULL
AND ranking >=3
;
WITH company_years AS(
SELECT company, 
YEAR(`date`) as years,
SUM(total_laid_off) as laid_off
FROM layoffs_final
GROUP BY company,years
ORDER BY years
),
company_ranking AS(
SELECT *,
dense_rank() OVER(PARTITION BY years ORDER BY laid_off desc) AS ranking
FROM company_years
)
SELECT *
FROM company_ranking
WHERE ranking <=3 AND years IS NOT NULL
;

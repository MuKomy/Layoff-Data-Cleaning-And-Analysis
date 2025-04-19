SELECT * FROM world_layoffs.layoffs;

-- Removing Duplicates
DROP TABLE layoffs_staging;


CREATE TABLE layoffs_staging
LIKE layoffs;


INSERT INTO layoffs_staging
SELECT * FROM layoffs;

INSERT INTO layoffs_staging
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as occurence
FROM layoffs;

SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE occurence >1;

DROP TABLE layoff_with_occurence;
CREATE TEMPORARY TABLE layoff_with_occurence
SELECT company, location, industry,total_laid_off, percentage_laid_off,`date`, stage, country, ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as occurence
FROM layoffs_staging;

SELECT * FROM layoff_with_occurence ;


ALTER TABLE layoffs_staging ADD COLUMN occurence INT;

WITH cte_layoffs_with_row_count
AS 
(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as occurence
FROM layoffs
)
#SELECT *
#FROM cte_layoffs_with_row_count
#WHERE occurence > 1;

#SELECT * FROM cte_layoffs_with_row_count WHERE company = "oda";

#SELECt * FROM cte_layoffs_with_row_count;

#SELECT COUNT(*) FROM cte_layoffs_with_row_count;

#INSERT INTO layoffs_staging
#SELECT * FROM cte_layoffs_with_row_count; 
;
SELECT COUNT(*) FROM layoff_with_occurence;
UPDATE layoffs_staging SET VALUES(SELECT * FROM cte_layoffs_with_row_count )

SELECT * FROM layoffs_staging WHERE company = "oda";

/*
ALTER TABLE layoffs_staging ADD COLUMN occurence INT;


UPDATE layoffs_staging SET occurence = layoff_with_occurence.occurence;


ALTER TABLE layoffs_staging
DROP COLUMN OCCURENCE;

ALTER TABLE layoffs_staging ADD COLUMN occurence INT;

INSERT INTO layoffs_staging  (occurence)
SELECT occurence FROM layoff_with_occurence;

SELECT * FROM layoffs_staging LIMIT 5000;

ALTER TABLE layoffs_staging DROP COLUMN occurence;
*/

# Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging;


UPDATE layoffs_staging
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging;

SELECT DISTINCT industry
FROM layoffs_staging
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT * FROM layoffs_staging;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM  country)
FROM layoffs_staging
ORDER BY 1;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM  country);

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;

SELECT str_to_date(`date`, '%m/%d/%Y') FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging;
SELECT * FROM layoffs;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `occurence` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging;
SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * FROM layoffs_staging;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- NULL VALUES

SELECT *
FROM layoffs_staging
WHERE industry ='' OR industry IS NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';


SELECT t1.industry AS t1_industry,t2.industry AS t2_industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE t1.industry ='' OR t1.industry IS NULL;

UPDATE layoffs_staging3 as t1
JOIN layoffs_staging3 as t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL
AND t2.industry IS NOT NULL);

SELECT * FROM layoffs_staging3 WHERE company = 'airbnb';

SELECT * FROM layoffs_staging3 WHERE industry IS NULL;

SELECT *
FROM layoffs_staging
WHERE industry IS NULL;


SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

ALTER TABLE layoffs_staging MODIFY COLUMN `date` DATE;


CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `occurence` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging3 SELECT * FROM layoffs_staging;

SELECT * FROM layoffs_staging3;

SELECT t1.industry AS t1_industry,t2.industry AS t2_industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
ON (t1.company = t2.company
AND t1.location = t2.location)
WHERE t1.industry ='' OR t1.industry IS NULL;



SELECT COUNT(*) FROM layoffs_staging3 WHERE industry IS NULL;

SELECT * FROM layoffs_staging3 WHERE industry IS NULL OR INDUSTRY = '';

CREATE TABLE layoffs_final AS SELECT * FROM layoffs_staging3;

INSERT INTO layoffs_staging4 SELECT * FROM layoffs_staging3;

-- DELETE DATA
SELECT * FROM layoffs_staging3;

SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging3 DROP COLUMN occurence;

DELETE FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT COUNT(*) FROM layoffs_staging3;
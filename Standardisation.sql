
-- Goal is to remove remove blank entries by first trying to fill them and if no solution to delete them
-- standardising column values and trimming them.

SELECT company, TRIM(company)
FROM Data_cleaning.layoffs_staging2;

UPDATE Data_cleaning.layoffs_staging2
SET company = TRIM(company); 

SET SQL_SAFE_UPDATES = 0;

SELECT DISTINCT industry
FROM Data_cleaning.layoffs_staging2
ORDER BY 1;

SELECT * 
FROM Data_cleaning.layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE Data_cleaning.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location 
FROM Data_cleaning.layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS trim_country
FROM Data_cleaning.layoffs_staging2
ORDER BY 1;

UPDATE Data_cleaning.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country = 'United States%';

SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM  Data_cleaning.layoffs_staging2;

UPDATE  Data_cleaning.layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

SELECT *
FROM Data_cleaning.layoffs_staging2;

UPDATE  Data_cleaning.layoffs_staging2
SET industry= NULL 
WHERE industry = '';



SELECT *
FROM Data_cleaning.layoffs_staging2 t1
JOIN Data_cleaning.layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE Data_cleaning.layoffs_staging2 t1
JOIN Data_cleaning.layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM Data_cleaning.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

    
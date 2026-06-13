
-- STEP 1: CREATE AND POPULATE LAYOFFS_STAGING 

-- sTEP 1
DROP TABLE IF EXISTS layoffs_staging; 

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging 
SELECT * 
FROM layoffs;

-- Check numbers
SELECT COUNT(*) FROM layoffs_staging; 



-- STEP 2: CREATE LAYOFFS_STAGING2 WITH THE ROW_NUM COLUMN


DROP TABLE IF EXISTS layoffs_staging2;

-- Best Practice: Instead of guessing data types as TEXT, 
-- use LIKE to copy the exact schema, then alter it to add row_num.
CREATE TABLE layoffs_staging2 LIKE layoffs;

ALTER TABLE layoffs_staging2 ADD COLUMN row_num INT;


-- STEP 3: INSERT THE WINDOW FUNCTION DATA


INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER(
           PARTITION BY company, location, total_laid_off, date, 
                        percentage_laid_off, industry, source, 
                        stage, funds_raised, country, date_added
       ) AS row_num 
FROM layoffs_staging;



SELECT COUNT(*) FROM layoffs_staging2;


-- duplicates (where row_num > 1)
SELECT * FROM layoffs_staging2 WHERE row_num > 1;

-- delete them
DELETE FROM layoffs_staging2
WHERE row_num > 1;


SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging2 
WHERE row_num > 1;

SELECT * FROM layoffs_staging;








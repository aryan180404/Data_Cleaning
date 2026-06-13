layoffs-data-cleaning

MySQL scripts to clean a raw layoffs dataset — removes duplicates, standardises values, and outputs an analysis-ready table. The original data is never touched.


Requirements


MySQL 8.0+
Data_cleaning schema created
layoffs table populated from layoffs.xlsx



Quick Start

Run the scripts in order from your MySQL client:

sqlSOURCE Duplicates_removal_data_cleaning_.sql;
SOURCE Standardisation.sql;

Clean data is available at:

sqlSELECT * FROM Data_cleaning.layoffs_staging2;


Schema

ColumnTypeNotescompanyvarcharTrimmed of whitespacelocationvarcharindustryvarcharStandardised; NULL where unknowntotal_laid_offintRows NULL here and in percentage_laid_off are droppedpercentage_laid_offfloatdatedateConverted from mm/dd/yyyy stringstagevarcharFunding stagefunds_raisedfloatcountryvarcharTrailing punctuation removeddate_addeddate


Scripts

Duplicates_removal_data_cleaning_.sql

Stages the raw data and removes duplicate rows.

layoffs  →  layoffs_staging  →  layoffs_staging2 (deduplicated)

Uses ROW_NUMBER() OVER (PARTITION BY ...) across all columns to flag duplicates, then deletes any row where row_num > 1.

sqlROW_NUMBER() OVER(
    PARTITION BY company, location, total_laid_off, date,
                 percentage_laid_off, industry, source,
                 stage, funds_raised, country, date_added
) AS row_num

Standardisation.sql

Fixes inconsistent values in layoffs_staging2 in place.

#ColumnFix1companyTRIM() whitespace2industryNormalise Crypto% variants → 'Crypto'3countryTRIM(TRAILING '.' FROM country)4dateSTR_TO_DATE(date, '%m/%d/%Y') → proper DATE5industry'' → NULL6industryPopulate NULL via self-join on company7allDrop rows where total_laid_off and percentage_laid_off are both NULL


Notes


SET SQL_SAFE_UPDATES = 0 is required for keyless DELETE/UPDATE — avoid in production.
MySQL-specific functions used: STR_TO_DATE, TRIM TRAILING.
layoffs_staging is an intermediate table and can be dropped after cleaning.

# layoffs-data-cleaning

MySQL scripts to clean a raw layoffs dataset. Removes duplicates, standardises values, and outputs an analysis-ready table. The original data is never touched.

---

## Requirements

- MySQL 8.0+
- Data_cleaning schema created
- layoffs table populated from layoffs.xlsx

---

## Quick Start

Run the scripts in order from your MySQL client:

    SOURCE Duplicates_removal_data_cleaning_.sql;
    SOURCE Standardisation.sql;

Clean data is available at:

    SELECT * FROM Data_cleaning.layoffs_staging2;

---

## Scripts

### Duplicates_removal_data_cleaning_.sql

Stages the raw data and removes duplicate rows.

Pipeline: layoffs -> layoffs_staging -> layoffs_staging2 (deduplicated)

Uses ROW_NUMBER() OVER (PARTITION BY ...) across all columns to flag duplicates, then deletes any row where row_num > 1.

### Standardisation.sql

Fixes inconsistent values in layoffs_staging2 in place.

1. company - TRIM() whitespace
2. industry - Normalise Crypto% variants to 'Crypto'
3. country - Remove trailing periods e.g. 'United States.' to 'United States'
4. date - Convert string mm/dd/yyyy to proper DATE type
5. industry - Convert empty strings to NULL
6. industry - Populate NULL values via self-join on company
7. all - Drop rows where total_laid_off and percentage_laid_off are both NULL

---

## Notes

- SET SQL_SAFE_UPDATES = 0 is required for keyless DELETE/UPDATE, avoid in production.
- MySQL-specific functions used: STR_TO_DATE, TRIM TRAILING.
- layoffs_staging is an intermediate table and can be dropped after cleaning.

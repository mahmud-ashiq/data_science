-- SQL Project- Data Cleaning

SELECT * FROM world_layoffs.layoffs;

-- Staging Table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- Remove duplicate values

#check for duplicates

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# checking duplicate values
SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

# another table with row_num
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#data insertion
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

#delete duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- Standardizing Data

#tirm country
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

#checking industry
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

#converting Crypto, Crypto Currency, CryptoCurrency to Crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

#checking location
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

#checking country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

# trimming '.'
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# changing data type of date column 
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Null values

# total_laid_off or percentage_laid_off is null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
OR percentage_laid_off IS NULL;

# both total_laid_off and percentage_laid_off is null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# delete if both total_laid_off and percentage_laid_off is null
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# null or empty industry
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

# updating empty string to null
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

# checking empty industry
SELECT t2.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# populate empty industry
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# dropping unnecessary columns
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

# final outpout
SELECT * 
FROM layoffs_staging2
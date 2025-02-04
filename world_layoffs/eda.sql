-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT location, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,
SUM(total) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`DATE`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`DATE`)
), company_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS `rank`
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE `rank` < 6;

WITH industry_year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`DATE`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry, YEAR(`DATE`)
), industry_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS `rank`
FROM industry_year
WHERE years IS NOT NULL
)
SELECT *
FROM industry_year_rank
WHERE `rank` < 6;

WITH country_year (country, years, total_laid_off) AS
(
SELECT country, YEAR(`DATE`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country, YEAR(`DATE`)
), country_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS `rank`
FROM country_year
WHERE years IS NOT NULL
)
SELECT *
FROM country_year_rank
WHERE `rank` < 6;
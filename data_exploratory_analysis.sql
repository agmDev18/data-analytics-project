-- Exploratory Data Analysis

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = 12000;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`);

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2;

SELECT SUBSTRING(`date`, 1, 7) AS `YEAR_MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `YEAR_MONTH`
ORDER BY `YEAR_MONTH`;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `YEAR_MONTH`, SUM(total_laid_off) AS total_month
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `YEAR_MONTH`
ORDER BY `YEAR_MONTH`
)
SELECT `YEAR_MONTH`, total_month, SUM(total_month) OVER(ORDER BY `YEAR_MONTH`) AS rolling_total
FROM Rolling_Total ;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;	

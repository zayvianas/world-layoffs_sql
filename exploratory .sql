-- Exploratory Data Analysis 

select *
from layoffs_staging2;

select company,  max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
group by company;


select company,  max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
where percentage_laid_off = 1
group by company;

select min(`date`), max(`date`)
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country 
order by 1 desc;

select year(`date`)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


select company, avg(percentage_laid_off)
from layoffs_staging2
group by company 
order by 2 desc;

select company, avg(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc;

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
group by `month`
order by 1 asc;

with rolling_total as 
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total
from layoffs_staging2
group by `month`
order by 1 asc
)

select `month`, total, sum(total) over(order by `month`) as rolling_total
from rolling_total; 

select company, year(`date`) as yeardate,sum(total_laid_off)
from layoffs_staging2
group by company,yeardate 
order by company asc;

with company_year (company, years, totallaidoff) as
(
select company, year(`date`) as yeardate,sum(total_laid_off)
from layoffs_staging2
group by company,yeardate 
)

select *,
dense_rank() over(partition by years order by totallaidoff desc) as ranking 
from company_year
where years is not null and totallaidoff is not null
group by company, years
order by ranking asc;
-- Data Cleaning Project

-- Load Data
select *
from layoffs;

-- Create Staging Table
create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

-- Remove Dupes
select *,
row_number()
over(partition by company, industry, total_laid_off, percentage_laid_off,`date` ) as row_num
from layoffs_staging;

-- cte that goes over rows for matches 
with dup_cte as (
select *,
row_number()
over(partition by company, industry, total_laid_off, percentage_laid_off,`date`, stage, country) as row_num
from layoffs_staging
)

select *
from dup_cte
where row_num >1;


-- Create Staging 2 Table
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

insert into layoffs_staging2
select *,
row_number()
over(partition by company, industry, total_laid_off, percentage_laid_off,`date`, stage, country) as row_num
from layoffs_staging;

select *
from layoffs_staging2
where row_num >1;

-- Didnt find any duplictes 


-- Standardize Data
update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;

select distinct location
from layoffs_staging2
order by 1;

select distinct company
from layoffs_staging2
order by 1;

select distinct stage
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like '%united state%';

select distinct country
from layoffs_staging2
order by 1;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2;

-- Null/ Blank Values

select *
from layoffs_staging2
where industry is null;

select *
from layoffs_staging2
where company = 'Bally''s Interactive';

-- Couldn't Populate Industry from data

-- Remove Unnessecary Columns/Rows
select *
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

delete 
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;

# 💼 Layoffs Data Cleaning & Analysis Project (MySQL)

This SQL project demonstrates how to clean and analyze a real-world dataset on global tech layoffs using **MySQL**. The dataset was originally collected from [Layoffs.fyi](https://layoffs.fyi) and used in the [Alex The Analyst – SQL Portfolio Project](https://www.youtube.com/@AlexTheAnalyst).

---

## 📁 Files Included

- `layoffs.csv` – Raw dataset before cleaning  
  [Raw Data](layoffs.csv)
- `cleaned_layoffs.csv` – SQL export of the cleaned dataset  
  [cleaned_layoffs.csv](cleaned_layoffs.csv)
- `Data_Cleaning_Project.sql` – Script to clean the raw data
  [SQL Data Cleaning Script](Data_Cleaning_Project.sql)
- `Data_Analysis_Project.sql` – Script to explore and analyze the cleaned data
  [SQL Data Analysis Script](Data_Analysis_Project.sql)

---

## 🧰 Tools Used

- **Database**: MySQL
- **Language**: SQL
- **Course Reference**: Alex The Analyst – Data Analyst Bootcamp

---

## 🧹 1. Data Cleaning (`Data_Cleaning_Project.sql`)

We start by cleaning the dataset to make it consistent and analysis-ready.

### 🔸 Step 1: Standardize Company Names

```sql
-- Convert company names to lowercase for consistency
UPDATE layoffs
SET company = LOWER(company);
```
### 🔸 Step 2: Identify & Remove Duplicate Rows

```sql
-- Create a CTE to assign row numbers
WITH ranked AS (
  SELECT *, 
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, date
           ORDER BY id
         ) AS row_num
  FROM layoffs
)
-- Delete duplicate rows
DELETE FROM layoffs
WHERE id IN (
  SELECT id FROM ranked WHERE row_num > 1
);
```
### 🔸 Step 3: Fill Missing total_laid_off Values
``` sql
-- Estimate total_laid_off where missing
UPDATE layoffs
SET total_laid_off = ROUND(percentage_laid_off * number_employees)
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NOT NULL;

```
### 🔸 Step 4: Convert Date Format


``` sql
-- Convert 'MM/DD/YYYY' to proper DATE format
UPDATE layoffs
SET date = STR_TO_DATE(date, '%m/%d/%Y');
```

# 📊 2. Data Analysis (`Data_Analysis_Project.sql`)

### 📈 Total Layoffs by Country
``` sql
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY country
ORDER BY total_layoffs DESC;
```
### 🗓️ Monthly Layoff Trends
``` sql
SELECT DATE_FORMAT(date, '%Y-%m') AS month, 
       SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY month
ORDER BY month;

```
### 🏢 Companies with the Most Layoffs
``` sql
SELECT company, SUM(total_laid_off) AS layoffs
FROM layoffs
GROUP BY company
ORDER BY layoffs DESC
LIMIT 10;

```
### ⚒ Top Industries Affected
```sql 
SELECT industry, SUM(total_laid_off) AS total
FROM layoffs
GROUP BY industry
ORDER BY total DESC;

```

### 🙌 Credits
<b> Dataset: Layoffs.fyi


<b> Tutorial: Alex The Analyst

#Conclusion
Over this project I have learned to enhance my ability to clean and analyze data using SQL and gained knowledge using MySQL

## 🧠 Conclusion

Throughout this project, I strengthened my skills in data cleaning and analysis using SQL, while gaining hands-on experience working with MySQL, From handling missing values and standardizing inconsistent data to writing queries that uncover real insights, this project gave me a clearer understanding of how to work with messy real-world data. 

It also helped me build confidence in structuring SQL scripts for both clarity, which is an essential part of any data professional's workflow.


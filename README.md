# 💼 Layoffs Data Cleaning & Analysis Project (MySQL)

This SQL project demonstrates how to clean and analyze a real-world dataset on global tech layoffs using **MySQL**. The dataset was originally collected from [Layoffs.fyi](https://layoffs.fyi) and used in the [Alex The Analyst – SQL Portfolio Project](https://www.youtube.com/@AlexTheAnalyst).

---

## 📁 Files Included

- `layoffs.csv` – Raw dataset before cleaning  
  👉 _[Link to raw dataset here]_  
- `clean_layoffs.sql` – SQL export of the cleaned dataset  
  👉 _[Link to cleaned dataset here]_  
- `Data_Cleaning_Project.sql` – Script to clean the raw data
- `Data_Analysis_Project.sql` – Script to explore and analyze the cleaned data

---

## 🧰 Tools Used

- **Database**: MySQL
- **Language**: SQL
- **Course Reference**: Alex The Analyst – SQL Portfolio Project

---

## 🧹 1. Data Cleaning (`Data_Cleaning_Project.sql`)

We start by cleaning the dataset to make it consistent and analysis-ready.

### 🔸 Step 1: Standardize Company Names

```sql
-- Convert company names to lowercase for consistency
UPDATE layoffs
SET company = LOWER(company);

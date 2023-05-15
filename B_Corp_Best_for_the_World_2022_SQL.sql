---------------------- BEST FOR THE WORLD 2022 --------------------------
------------------------------- ABOUT -----------------------------------

-- "Every year, B Lab recognizes the top-performing B Corps creating great impact through their businesses. 
-- These B Corps are named Best for the World™, as their verified scores in the five impact areas 
-- evaluated on the B Impact Assessment - community, customers, environment, governance, and workers - 
-- are amongst the global top 5% in their corresponding size group."
-- https://www.bcorporation.net/en-us/best-for-the-world/
-- The latest available Best For The World list is from 2022
-- Objective: use tables 'b_corp_impact_data' and 'b_corp_best_world_2022' to
-- analyze data on Best For the World 2022 companies and answer questions
-- Primary key in both tables: company_id


---------------------- GET TO KNOW THE DATA -----------------------------

-- B Corp Impact Data: 
-- comprehensive information on all certified B Corps as of March 2023
-- See how many rows are in the table
SELECT COUNT(*)
FROM b_corp_impact_data
-- 6130, same dataset as in the Python project
-- 22 columns

-- Best For The World 2022:
-- information on companies recognized as Best For The World in 2022
-- See how many rows are in this table
SELECT COUNT(*)
FROM b_corp_best_world_2022
-- 1023 rows = distinct companies
-- 5 columns

-- In order to analyze the Best For The World 2022 companies and
-- answer questions related to industry, size, country etc
-- we need to join the two tables


------------------------------ OVERVIEW --------------------------------
-- Create view to display general company information,
-- including company size, industry and overall score
-- as well as award category

SELECT
    all_bcorp.company_name,
	all_bcorp.country,
	all_bcorp.city,
    best22.award_category,
    best22.size_category,
	all_bcorp.industry_category,
    all_bcorp.industry,
    all_bcorp.overall_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
ORDER BY all_bcorp.overall_score DESC

-- The inner join resulted 941 rows, meaning 941 companies
-- 'best22' contains 1023 companies
-- Reason behind the discrepancy: decertified companies as of March 2023


--------------- BEST FOR THE WORLD COMPANIES BY SIZE, INDUSTRY--------------

-- What is the size distribution for Best For The World 2022 companies?
-- Large or small companies were more likely to get recognized as Best For The World?
SELECT
    best22.size_category,
	COUNT(all_bcorp.company_id) AS awarded_companies   
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
GROUP BY best22.size_category
ORDER BY awarded_companies DESC

-- Most Best For The World 2022 B Corps are small companies with 1-9 and 10-49 employees.
-- Note: Most certified B Corps fall into these two size categories.

-- Which industry had the most Best For The World companies in 2022?
-- What is the median overall score in each industry?
SELECT
	all_bcorp.industry,
    COUNT(all_bcorp.company_id) AS awarded_companies,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY all_bcorp.overall_score) AS median_overall_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
GROUP BY all_bcorp.industry
ORDER BY awarded_companies DESC

-- 1. Investment advising: 61 companies, median score: 118.1
-- 2. Management consultant - for-profits: 41 companies, median score: 100.9
-- 3. Food products: 40 companies, median score: 104.3

-- See Best For The World 2022 companies in the Investment advising industry
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	best22.award_category,
	best22.size_category,
	all_bcorp.overall_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE all_bcorp.industry = 'Investment advising'
ORDER BY all_bcorp.overall_score DESC

-- Mostly based in the US (or Australia or UK)
-- They were mostly awarded in Customers category


------------------- VIEW WITH AWARD CATEGORY YES/NO COLUMN -------------------

-- Create a view with all of the 'b_corp_impact_data' companies included
-- adding 'awarded_2022' Yes/No column column using LEFT JOIN

SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	all_bcorp.industry,
	all_bcorp.size, 
	all_bcorp.overall_score,
	best22.award_category,
	CASE
		WHEN best22.award_category IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS awarded_2022
FROM b_corp_impact_data AS all_bcorp
LEFT JOIN b_corp_best_world_2022 AS best22
ON all_bcorp.company_id = best22.company_id

-- Show Best For World 22 companies with overall score above 150 using CTE
-- awarded 'Yes' and overall score > 150
WITH CTE_Awarded AS
(
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	all_bcorp.industry,
	all_bcorp.size, 
	all_bcorp.overall_score, 
	CASE
		WHEN best22.award_category IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS awarded_2022
FROM b_corp_impact_data AS all_bcorp
LEFT JOIN b_corp_best_world_2022 AS best22
ON all_bcorp.company_id = best22.company_id
)

SELECT 
	company_name,
	overall_score
FROM CTE_Awarded
WHERE awarded_2022 = 'Yes'
AND overall_score > 150
ORDER BY overall_score

-- Number and percentage of awarded vs not awarded using the CTE above
WITH CTE_Awarded AS
(
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	all_bcorp.industry,
	all_bcorp.size, 
	all_bcorp.overall_score, 
	CASE
		WHEN best22.award_category IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS awarded_2022
FROM b_corp_impact_data AS all_bcorp
LEFT JOIN b_corp_best_world_2022 AS best22
ON all_bcorp.company_id = best22.company_id
)

SELECT 
	COUNT(company_name) AS no_of_companies,
	CTE_Awarded.awarded_2022,
	ROUND(CAST(COUNT(company_name)*100 AS DECIMAL) / (SELECT COUNT(company_name) FROM CTE_Awarded),2) AS percent_of_total
	FROM CTE_Awarded
GROUP BY CTE_Awarded.awarded_2022
ORDER BY percent_of_total


-------------------- MINIMUM AND MAXIMUM OVERALL SCORE --------------------

-- What was the minimum and maximum overall score for Best For World companies in 2022?
SELECT
	MIN(all_bcorp.overall_score) AS min_score,
	MAX(all_bcorp.overall_score) AS max_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id

-- We have seen earlier that Dr. Bronner's has 206.7 score
-- 80.0 is the minimum threshold to get certified as B Corp

-- Which Best For World 2022 company/companies have 80.0 overall score?
SELECT
	all_bcorp.company_name,
	all_bcorp.industry,
	best22.award_category,
	all_bcorp.overall_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE all_bcorp.overall_score = 80

-- There are 3 such companies.

-- Industries with Best For World 2022 companies having minimum overall score > 120
SELECT
	all_bcorp.industry,
	MIN(all_bcorp.overall_score) AS min_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
GROUP BY all_bcorp.industry
HAVING MIN(all_bcorp.overall_score) > 120
ORDER BY min_score

-- Computer & electronics, Publishing - newspapers & magazines, 
-- Financial transaction processing, Home health care, Wind power generation


-------------------------- AWARD CATEGORY ----------------------------
-- What is the distribution of the different award categories?
SELECT
    best22.award_category,
	COUNT(all_bcorp.company_id) AS awarded_companies   
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
GROUP BY best22.award_category
ORDER BY awarded_companies DESC

-- Multiple award categories can be included in the same cell for a company
-- divided by ;
-- 1. Environment (185+combined)
-- 2. Community (171+combined)
-- 3. Customers (169 + comdined)

-- Which companies got recognized in 3 categories?
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	best22.award_category,
	best22.size_category,
	all_bcorp.overall_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE best22.award_category LIKE '%;%;%'
ORDER BY all_bcorp.overall_score DESC

-- Number of companies by number of award categories
SELECT
	COUNT(all_bcorp.company_id) AS no_of_companies,
	CASE
		WHEN best22.award_category LIKE '%;%;%' THEN '3 categories'
		WHEN best22.award_category LIKE '%;%' THEN '2 categories'
		ELSE '1 category'
	END AS awarded_in
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
GROUP BY awarded_in
ORDER BY no_of_companies DESC

-- 852 companies awarded in 1 category
-- 80 companies awarded in 2 categories
-- 9 companies awarded in 3 categories
-- no company awarded in 4 or all 5 categories

-- Which companies were recognized in the Environment category?
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	all_bcorp.industry,
	best22.award_category,
	best22.size_category,
	all_bcorp.impact_area_community
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE best22.award_category LIKE '%Environment%'
ORDER BY all_bcorp.impact_area_community DESC

-- Which industries have the most companies awarded in the Environment category?
SELECT
	all_bcorp.industry,
	COUNT(all_bcorp.company_id) AS no_of_companies,
	ROUND(AVG(all_bcorp.impact_area_environment),2) AS avg_environment_score
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE best22.award_category LIKE '%Environment%'
GROUP BY all_bcorp.industry
ORDER BY no_of_companies DESC

-- 1. Apparel (14 companies, avg. score 52.48)
-- 2. Solar panel installation (13 companies, avg. score 42.38)
-- 3. Beverages (11 companies, avg. score 42.10)

-- Best for the World 2022 companies in the Apparel industry,
-- any award category
SELECT
	all_bcorp.company_name,
	all_bcorp.country,
	best22.award_category,
	best22.size_category,
	all_bcorp.impact_area_environment,
	all_bcorp.impact_area_customers,
	all_bcorp.impact_area_worker
FROM b_corp_impact_data AS all_bcorp
INNER JOIN b_corp_best_world_2022 AS best22
    ON all_bcorp.company_id = best22.company_id
WHERE all_bcorp.industry = 'Apparel'
ORDER BY all_bcorp.impact_area_environment DESC


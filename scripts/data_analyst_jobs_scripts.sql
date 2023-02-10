-- 1.	How many rows are in the data_analyst_jobs table?

SELECT COUNT(*)
FROM data_analyst_jobs

-- 1793 rows

-- 2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT *
FROM data_analyst_jobs
Limit 10;

--	ExxonMobil

-- 3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN';

-- 21 in TN

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY')

--	27 in TN or KY

-- 4.	How many postings in Tennessee have a star rating above 4?

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE star_rating > 4;

--	416 postings

-- 5.	How many postings in the dataset have a review count between 500 and 1000?

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

--	151


-- 6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the 			state as `avg_rating`. Which state shows the highest average rating?

SELECT location, AVG(star_rating) as avg_rating
FROM data_analyst_jobs
GROUP BY location
HAVING AVG(star_rating) IS NOT NULL
ORDER BY avg_rating DESC;

--	NE

-- 7.	Select unique job titles from the data_analyst_jobs table. How many are there?

SELECT COUNT(*)
FROM data_analyst_jobs

-- 8.	How many unique job titles are there for California companies?

SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE location = 'CA';

--	230 unique titles

-- 9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT company, AVG(star_rating) as avg_rating
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY company;

-- 	40 companies plus 1 qualifying NULL value

-- 10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

SELECT company, AVG(star_rating) as avg_rating
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY company
ORDER BY avg_rating DESC;

--	General Motors with 4.199. Appears to be tied with a five other comapanies. 

-- 11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE LOWER(title) LIKE '%analyst%';

SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE LOWER(title) LIKE '%analyst%';


SELECT title, COUNT(title)
FROM data_analyst_jobs
WHERE LOWER(title) LIKE '%analyst%'
GROUP BY title;

--	1669 total jobs. 774 distinct job titles

-- 12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

SELECT COUNT(*)
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE '%analyst%' AND LOWER(title) NOT LIKE '%analytics%';

SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE '%analyst%' AND LOWER(title) NOT LIKE '%analytics%';


SELECT title
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE '%analyst%' AND LOWER(title) NOT LIKE '%analytics%';

--	4 jobs. 3 of the 4 have the word "data" 

-- **BONUS:**
-- You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 
--  - Disregard any postings where the domain is NULL. 
--  - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 
--   - Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?

SELECT domain, COUNT(domain) as num_domain
FROM data_analyst_jobs
WHERE days_since_posting > 21
	AND LOWER(skill) LIKE '%sql%'
	AND domain IS NOT NULL
GROUP BY domain
ORDER BY num_domain DESC;

--	Internet and Software (62); Banks and Financial Services (61); Consulting and Business Services (57); Healthcare (52)

-- BONUS^2

-- 1. For each company, give the company name and the difference between its star rating and the national average star rating.
	 
SELECT d.company, 
	AVG(d.star_rating) as avg_rating,
	AVG(d.star_rating) - 
		(SELECT AVG(d2.star_rating)
		FROM data_analyst_jobs as d2) as difference_from_national
FROM data_analyst_jobs as d
INNER JOIN data_analyst_jobs as d2
ON d.company=d2.company AND d.star_rating IS NOT NULL
GROUP BY d.company
ORDER BY difference_from_national DESC,company;



-- 2. Using a correlated subquery: For each company, give the company name, its domain, its star rating, and its domain average star rating

SELECT d.company as company_name,
	d.domain as domain,
	d.star_rating as rating,
	(SELECT AVG(star_rating)
	FROM data_analyst_jobs as sub
	WHERE d.domain = sub.domain) as domain_avg
FROM data_analyst_jobs as d
ORDER BY domain, rating DESC, company_name;

-- 3. Repeat question 2 using a CTE instead of a correlated subquery
WITH c AS (
SELECT AVG(star_rating)
	FROM data_analyst_jobs as sub
	WHERE d.domain = sub.domain )

SELECT d.company as company_name,
	d.domain as domain,
	d.star_rating as rating,
	c as domain_avg 
FROM data_analyst_jobs as d
ORDER BY domain, rating DESC, company_name;


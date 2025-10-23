select * from [dbo].[cleaned_world_economics]

--2. Top 10 countries by GDP

SELECT top 10 name, GDP
FROM cleaned_world_economics
ORDER BY GDP DESC

--3. GDP per capita

SELECT top 10 name, GDP, Population,
       ROUND(GDP * 1.0 / Population, 2) AS GDP_Per_Capita
FROM cleaned_world_economics
ORDER BY GDP_Per_Capita DESC
--KPI 

SELECT 
    ROUND(AVG(gdp_growth) * 100, 1) AS Overall_Avg_GDP_Growth_Percent
FROM cleaned_world_economics;
SELECT 
    ROUND(AVG(inflation_rate) , 1) AS Avg_Inflation
FROM cleaned_world_economics;

SELECT 
    CONCAT(ROUND(SUM(GDP)/1000, 1), 'K') AS TOTAGDP
FROM cleaned_world_economics;

SELECT CONCAT(ROUND(SUM(population)/1000,1),'K') FROM cleaned_world_economics;
 



--4. Average economic indicators by region


SELECT region,
     ROUND(AVG("gdp_growth"), 2) AS Avg_GDP_Growth,
       ROUND(AVG("inflation_rate"), 2) AS Avg_Inflation,
       ROUND(AVG("jobless_rate"), 2) AS Avg_Jobless
FROM cleaned_world_economics
GROUP BY region;

--5. Countries with high debt-to-GDP ratio (>100%)

SELECT name, GDP, "debt_gdp"
FROM cleaned_world_economics   WHERE "debt_gdp" > 100
ORDER BY "debt_gdp" DESC;


--6. Current Account Balance Ranking
SELECT  top 10 name, "current_account"
FROM cleaned_world_economics 
ORDER BY "current_account" DESC




-- 7. Top 10 most populous countries
SELECT TOP 10 name, population
FROM cleaned_world_economics
ORDER BY population DESC;

-- 8. Countries with both high GDP growth (>5%) and low jobless rate (<5%)
SELECT name, gdp_growth, jobless_rate
FROM cleaned_world_economics
WHERE gdp_growth > 5 AND jobless_rate < 5
ORDER BY gdp_growth DESC;

-- 9. Regional GDP share (sum)
SELECT region, SUM(gdp) AS Total_GDP
FROM cleaned_world_economics
GROUP BY region
ORDER BY Total_GDP DESC;

-- 10. Correlation check: GDP vs Debt-to-GDP
SELECT name, gdp, debt_gdp
FROM cleaned_world_economics
WHERE gdp IS NOT NULL AND debt_gdp IS NOT NULL
ORDER BY debt_gdp DESC;

-- 11. Countries with negative current account (deficit)
SELECT name, current_account
FROM cleaned_world_economics
WHERE current_account < 0
ORDER BY current_account ASC;

-- 12. Countries with strong budget surplus
SELECT TOP 10 name, gov_budget
FROM cleaned_world_economics
WHERE gov_budget > 0
ORDER BY gov_budget DESC;




SELECT name, MIN(jobless_rate) AS Min_Jobless_Rate
FROM cleaned_world_economics
GROUP BY name
ORDER BY Min_Jobless_Rate ;


SELECT name, MAX(jobless_rate) AS MAX_Jobless_Rate
FROM cleaned_world_economics
GROUP BY name
ORDER BY MAX_Jobless_Rate DESC;

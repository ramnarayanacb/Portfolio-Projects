Select * 
from PortfolioPorject..CovidDeaths
order by 3, 4

-- that numbering after the orderby is called ordinal positioning -simply columns 1,2 etc.. 
Select * 
from PortfolioPorject..CovidVaccinations
order by 3, 4


/*
AT first we can findout the data types of each col using concat fxn or with out using concat 
SELECT 
    CONCAT(COLUMN_NAME, ' - ', DATA_TYPE) AS COLUMN_DATA_TYPES
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidDeaths';

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidDeaths';

*/
/* Since making changes of the data types when we get into raw data by doing right click the table - design - change it -
if it is blocked then do this To change this option, on the Tools menu, click Options, expand Designers, and then click Table and Database Designers. 
Select or clear the Prevent saving changes that require the table to be re-created check box.
*/



SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidDeaths';


SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidVaccinations';



-- converted date format bcoz while doing order by it orders under the date format 
--instead of year so i convereted the date column to date format in yyyy-mm-dd

select 
		location,  
		date, 
		total_cases, 
		new_cases, 
		total_deaths, 
		population
from 
PortfolioPorject..CovidDeaths
order by 1,2;

UPDATE PortfolioPorject..CovidDeaths
SET date = CONVERT(date, RIGHT(date, 4) + '-' + SUBSTRING(date, 4, 2) + '-' + LEFT(date, 2), 120);

select 
	location,  
	date, 
	total_cases,
	total_deaths,
	CASE
		WHEN total_cases = 0 OR total_deaths =0 THEN NULL
		ELSE (((Convert(decimal(10, 2),total_deaths)/total_cases)*100))
	END as Death_Percen
From PortfolioPorject .. CovidDeaths
where location like '%states%'
Order by 1,2;


-- total deaths vs population of the country or particular country 
select 
	location,  
	date, 
	total_cases,
	total_deaths,
	population,
	CASE
		WHEN population=0 OR total_cases = 0 OR total_deaths =0 THEN NULL
		ELSE (((Convert(decimal(10, 2),total_deaths)/population)*100))
	END as Death_Percen_against_popu
From PortfolioPorject .. CovidDeaths
--where location like '%India%'
Order by 1,2;

-- total cases vs population of the country or particular country 
Select 
	location,
	CONVERT(DATE, 
    RIGHT(date, 4) + '-' + 
    SUBSTRING(date, 4, 2) + '-' + 
    LEFT(date, 2), 120) AS Date, 
	continent,
	total_cases,
	total_deaths,
	population,
	CASE
		When total_cases = 0 OR population=0 THEN NULL
		ELSE (((CONVERT(decimal(18, 2), total_cases) / CONVERT(decimal(18, 2), population)) * 100))
	END as cases_against_population
From PortfolioPorject..CovidDeaths
--where location like '%India%'
order by 1,2;


-- Max infection rate or total cases of an country versus with its population 
/*Always use aggregate function properly and in the below query syntax multiplied 1.0 with totatl cases because converting them into decimal*/

SELECT 
	location,
	population,
	continent,
	MAX(total_cases) as high_infection_rate,
	CASE
		WHEN population=0 OR MAX(total_cases)=0 THEN NULL
		ELSE (MAX((total_cases*1.0))/MAX(population))*100
	END as Infection_rate_against_population
FROM PortfolioPorject..CovidDeaths
GROUP BY 
  location, 
  continent,
  population
order by Infection_rate_against_population Desc;

-- highest death rate against population wrto country 

SELECT 
	location,
	MAX(total_deaths) as highest_death_rate_Wrt_location
FROM PortfolioPorject..CovidDeaths
where continent is not NULL AND continent != ''
GROUP BY location
order by highest_death_rate_Wrt_location Desc;


/*Select * 
from PortfolioPorject..CovidDeaths
where continent is not NULL AND continent != ''
order by 3, 4
*/

--Breaking up the data via continent 

-- 1st query gets the accurate because i did include null and empty spaces in continent column
-- 2nd query doesnt includes the null and empty rows in the continent column so the output is different 
/*The empty rows occured because due to the import as flat file csv format so it didnt fill the empty rows as nulls 
if we do import as an excel it shows Null */
SELECT 
	location,
	MAX(total_deaths) as highest_death_rate_Wrt_Continents
FROM PortfolioPorject..CovidDeaths
where continent = '' 
GROUP BY location
order by highest_death_rate_Wrt_Continents Desc;
-- highest death count wrt to continents
SELECT 
	continent,
	MAX(total_deaths) as highest_death_rate_Wrt_Continents
FROM PortfolioPorject..CovidDeaths
where  continent != '' AND continent is NOT NULL
GROUP BY continent
order by highest_death_rate_Wrt_Continents Desc;

-- Global output
select 
	--location,  
	CONVERT(DATE, 
    RIGHT(date, 4) + '-' + 
    SUBSTRING(date, 4, 2) + '-' + 
    LEFT(date, 2), 120) AS Date, 
	--continent,
	SUM(new_cases) as new_cases,
	SUM(new_deaths) as new_deaths,
	CASE
		WHEN SUM(new_deaths) = 0 THEN  NULL
		ELSE (SUM(new_deaths)/SUM(new_cases*1.0))*100 
	END as Global_death_percen
From PortfolioPorject .. CovidDeaths
where continent != '' AND continent is NOT NULL
group by date
Order by 1,2;

select 
	--location,  
	--continent,
	SUM(new_cases) as new_cases,
	SUM(new_deaths) as new_deaths,
	CASE
		WHEN SUM(new_deaths) = 0 THEN  NULL
		ELSE (SUM(new_deaths)/SUM(new_cases*1.0))*100 
	END as Global_death_percen
From PortfolioPorject .. CovidDeaths
where continent != '' AND continent is NOT NULL
--group by date
Order by 1,2;


-- THe total population vs vaccination or vaccinated
select 
*
from 
PortfolioPorject..CovidVaccinations
order by 1,2;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'CovidVaccinations';

UPDATE PortfolioPorject..CovidVaccinations
SET date = CONVERT(date, RIGHT(date, 4) + '-' + SUBSTRING(date, 4, 2) + '-' + LEFT(date, 2), 120);





Select * 
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, 
		dea.date, 
		dea.population , 
		vac.new_vaccinations
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent != '' AND dea.continent is NOT NULL
order by 2,3;

UPDATE PortfolioPorject..CovidVaccinations
SET new_vaccinations = NULLIF(new_vaccinations, '');

--1st filtering(rolled) the vaccination total partitioned by location and ordered by date and location 

Select dea.continent, dea.location, 
		dea.date, 
		dea.population , 
		vac.new_vaccinations,
		SUM(CAST (vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as peoplevaccinated_rolled
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent != '' AND dea.continent is NOT NULL
order by 2,3;

--2nd Creating CTE to find the vaccinated people among the population in terms of percentage 
--We can create temp table too
With CTE_1 (continent,location,date,population,new_vaccination,peoplevaccinated_rolled)
AS
(
Select dea.continent, 
		dea.location, 
		dea.date, 
		dea.population , 
		vac.new_vaccinations,
		SUM(CAST (vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS peoplevaccinated_rolled
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent != '' AND dea.continent is NOT NULL
)
Select *,
(peoplevaccinated_rolled*1.0/population)*100 as vaccinated_against_population
FROM CTE_1
order by 2,3;


-- creating the above via TEMP table
DROP TABLE if exists #TT1
CREATE TABLE #TT1 (continent nvarchar(255),location nvarchar(255),date DATE,population numeric,new_vaccination int,peoplevaccinated_rolled int);

INSERT INTO #TT1
Select dea.continent, 
		dea.location, 
		dea.date, 
		dea.population , 
		vac.new_vaccinations,
		 SUM(CAST(ISNULL(vac.new_vaccinations, 0) AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS peoplevaccinated_rolled
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
--where dea.continent != '' AND dea.continent is NOT NULL;

Select *,
	CASE
		WHEN population = 0 OR peoplevaccinated_rolled = 0 THEN NULL
		ELSE (peoplevaccinated_rolled*1.0/population)*100 
	END AS vaccinated_against_population
FROM #TT1
order by 2,3;


--Creating views for data visualization on later purpose
USE PortfolioPorject

DROP VIEW IF EXISTS vaccinated_percent_wrt_population

CREATE VIEW vaccinated_percent_wrt_population as
Select dea.continent, 
		dea.location, 
		dea.date, 
		dea.population , 
		vac.new_vaccinations,
		 SUM(CAST(ISNULL(vac.new_vaccinations, 0) AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS peoplevaccinated_rolled
FROM PortfolioPorject..CovidDeaths as dea
JOIN PortfolioPorject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent != '' AND dea.continent is NOT NULL;
--order by 2,3

/*The Below things done because at first the view was created but didnt appear in the object folder because
it came under master database so identified it,removed it and recreated it in wrt my database portfolioporject */
/*SELECT * FROM sys.views WHERE name = 'vaccinated_percent_wrt_population'
SELECT 
    v.name AS ViewName, 
    s.name AS SchemaName, 
    DB_NAME() AS DatabaseName
FROM 
    sys.views v
INNER JOIN 
    sys.schemas s ON v.schema_id = s.schema_id
WHERE 
    v.name = 'vaccinated_percent_wrt_population';

USE master;
DROP VIEW vaccinated_percent_wrt_population;
*/

Select * from vaccinated_percent_wrt_population;

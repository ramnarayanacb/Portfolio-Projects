/*for tableau we have created a sheet in excel or WPS using the below query and that query is global death percent -1*/
select 
	--location,  
	--continent,
	SUM(new_cases) as total_cases,
	SUM(new_deaths) as total_deaths,
	CASE
		WHEN SUM(new_deaths) = 0 THEN  NULL
		ELSE (SUM(new_deaths)/SUM(new_cases*1.0))*100 
	END as Global_death_percentage
From PortfolioPorject .. CovidDeaths
where continent != '' AND continent is NOT NULL
--group by date
Order by 1,2;


/*Step 2*/
--Since i didnt altered the empty rows to null we have to specify it has empty strings so we can get the output

SELECT 
	location,
	MAX(total_deaths) as highest_death_rate_Wrt_Continents
FROM PortfolioPorject..CovidDeaths
where continent ='' and location not in ('World','European Union', 'International')
GROUP BY location
order by highest_death_rate_Wrt_Continents Desc;

/*Step3*/
SELECT 
	location,
	population,
	--continent,
	MAX(total_cases) as high_infection_rate,
	CASE
		WHEN population=0 OR MAX(total_cases)=0 THEN NULL
		ELSE (MAX((total_cases*1.0))/MAX(population))*100
	END as Infection_rate_against_population
FROM PortfolioPorject..CovidDeaths
GROUP BY 
  location, 
  --continent,
  population
order by Infection_rate_against_population Desc;

/*Step 4*/
SELECT 
	location,
	population,
	date,
	MAX(total_cases) as high_infection_rate,
	CASE
		WHEN population=0 OR MAX(total_cases)=0 THEN NULL
		ELSE (MAX((total_cases*1.0))/MAX(population))*100
	END as Infection_rate_against_population
FROM PortfolioPorject..CovidDeaths
GROUP BY 
  location, 
  population,
  date
order by Infection_rate_against_population Desc;

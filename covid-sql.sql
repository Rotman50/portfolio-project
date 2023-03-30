SELECT * FROM covid..coviddeaths
where continent is not null
ORDER BY 3,4





--Comparing Total Cases VS Total Deaths

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 as PercentageOfPopulationInfected
FROM covid..coviddeaths
where continent is not null
ORDER BY 1,2;


--comparing population vs total cases

SELECT location, date, population, total_cases, (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 as PercentageOfPopulationInfected
FROM covid..coviddeaths
where continent is not null
ORDER BY 1,2;

--comparing countries with the highest death count per population

SELECT location, MAX(CAST(total_cases as int)) AS TotalDeathCount
FROM covid..coviddeaths
--WHERE location LIKE '%State%'
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Group By Continent 
SELECT continent, MAX(CAST(total_cases as int)) AS TotalDeathCount
FROM covid..coviddeaths
--WHERE location LIKE '%State%'
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Global Numbers
SELECT  SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as float)) as TotalDeaths,
SUM(new_deaths) / NULLIF(SUM(new_cases), 0)*100 as DeathRate
FROM covid..coviddeaths
WHERE  continent is not null 
--GROUP BY date
ORDER BY 1,2

-- USE CTE
with popvsvac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVacinated)
as
(
    Select D.continent, D.location, D.date, D.population, CAST(V.new_vaccinations AS bigint),
    SUM(CAST(V.new_vaccinations AS bigint)) OVER (Partition by D.location ORDER BY D.location) as RollingPeopleVaccinated
    FROM covid..coviddeaths D
    join covid..covidvaccination V
    ON D.location = V.location
    AND D.date = V.date
    WHERE D.continent is not null
)
SELECT * FROM popvsvac




CREATE VIEW PercentagePopulationVaccination AS 
SELECT D.continent, D.location, D.date, D.population, CAST(V.new_vaccinations AS bigint) AS new_vaccinations,
SUM(CAST(V.new_vaccinations AS bigint)) OVER (PARTITION BY D.location ORDER BY D.location) AS RollingPeopleVaccinated
FROM covid..coviddeaths D
JOIN covid..covidvaccination V ON D.location = V.location AND D.date = V.date
WHERE D.continent IS NOT NULL;

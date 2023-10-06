-- Select data that we are going to be using.
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Total cases vs total deaths in United States.
-- Shows likelihood of dying if you contract Covid.
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM CovidDataProject..CovidDeaths
WHERE location like '%states%'
AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at total cases vs population
-- Shows what percentage of population has gotten Covid.
SELECT location, date, total_cases, population, (total_cases/population)*100 AS contraction_percentage
FROM CovidDataProject..CovidDeaths
WHERE location like '%states%'
AND continent IS NOT NULL
ORDER BY 1,2

--Countries with highest infection rate compared to population.
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS percent_population_infected
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY population, location
ORDER BY percent_population_infected DESC

-- Showing countries with the highest death count per population.
SELECT location, MAX(cast(total_deaths AS INT)) AS total_death_count
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY total_death_count DESC

-- Showing continents with the highest death count per population.
SELECT continent, MAX(cast(total_deaths AS INT)) AS total_death_count
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT  NULL
GROUP BY continent 
ORDER BY total_death_count DESC

-- Showing continents with highest death count.
SELECT continent, MAX(cast(total_deaths AS INT)) AS total_death_count
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT  NULL
GROUP BY continent 
ORDER BY total_death_count DESC

-- Death percentage by country.
SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) as total_deaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases) * 100 AS death_percentage
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Death percentage of world.
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) as total_deaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases) * 100 AS death_percentage
FROM CovidDataProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Total population vs vaccinations.
-- Shows percentage of population that has recieved at least one covid vaccine.
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS rolling_people_vaccinated
FROM CovidDataProject..CovidDeaths deaths
JOIN CovidDataProject..CovidVaccinations vaccinations
	ON deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE to perform calculation on partition By in previous query
;WITH population_vs_vaccination (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS rolling_people_vaccinated
FROM CovidDataProject..CovidDeaths deaths
JOIN CovidDataProject..CovidVaccinations vaccinations
	ON deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population) * 100 
FROM population_vs_vaccination

-- Creating view to store data for later visualizations
GO
CREATE VIEW percent_population_vaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
SUM(CAST(vaccinations.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS rolling_people_vaccinated
FROM CovidDataProject..CovidDeaths deaths
JOIN CovidDataProject..CovidVaccinations vaccinations
	ON deaths.location = vaccinations.location
	AND deaths.date = vaccinations.date
WHERE deaths.continent IS NOT NULL
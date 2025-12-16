
-- ==============================
-- COVID-19 EDA SQL Script
-- ==============================

-- 1. Inspect the original CovidDeaths table

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 2. Total Cases vs Total Deaths for Egypt

SELECT location, date, total_cases, total_deaths, 
       (total_deaths*100.0/total_cases) AS Deaths_by_Percentage
FROM PortfolioProjects..CovidDeaths
WHERE location LIKE '%Egypt%' AND continent IS NOT NULL
ORDER BY location, date;

-- 3. Total Cases vs Population (Global)

SELECT location, date, population, total_cases, 
       (total_cases*100.0/population) AS Population_By_Percentage
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 4. Countries with highest infection rate relative to population

SELECT location, population, MAX(total_cases) AS TotalCases,
       MAX((total_cases*100.0)/population) AS PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;

-- 5. Countries with highest deaths counts

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathsCount
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathsCount DESC;

-- 6. Deaths by continent

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathsCount
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathsCount DESC;

-- 7. Global Numbers

SELECT SUM(new_cases) AS TotalCases,
       SUM(CAST(new_deaths AS INT)) AS TotalDeaths, 
       SUM(CAST(new_deaths AS INT))*100.0 / SUM(new_cases) AS DeathsPercentage
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL;

-- 8. Vaccination Analysis: Rolling totals

WITH PopVsVac AS (
    SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
           SUM(CONVERT(INT, Vac.new_vaccinations)) OVER(PARTITION BY Dea.location 
                                                        ORDER BY Dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProjects..CovidDeaths AS Dea
    JOIN PortfolioProjects..CovidVaccination AS Vac
        ON Dea.location = Vac.location AND Dea.date = Vac.date
    WHERE Dea.continent IS NOT NULL
)
SELECT *,
       (RollingPeopleVaccinated*100.0 / population) AS PercentageOfPeopleVaccinated
FROM PopVsVac
ORDER BY location, date;

-- 9. Create a Table for Rolling Vaccinations

DROP TABLE IF EXISTS PercentagePopulationVaccinated;
CREATE TABLE PercentagePopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_Vaccination NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO PercentagePopulationVaccinated
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
       SUM(CONVERT(INT, Vac.new_vaccinations)) OVER(PARTITION BY Dea.location 
                                                    ORDER BY Dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS Dea
JOIN PortfolioProjects..CovidVaccination AS Vac
    ON Dea.location = Vac.location AND Dea.date = Vac.date;

-- 10. Create a View for Easy Visualization

CREATE VIEW PercentagePopulationVaccination AS
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
       SUM(CONVERT(INT, Vac.new_vaccinations)) OVER(PARTITION BY Dea.location 
                                                    ORDER BY Dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths AS Dea
JOIN PortfolioProjects..CovidVaccination AS Vac
    ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL;












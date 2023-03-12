SELECT CovidVaccinations.location, CovidVaccinations.date, population, total_vaccinations, new_cases, new_vaccinations, positive_rate  FROM CovidVaccinations
INNER JOIN CovidDeaths
ON CovidVaccinations.iso_code=CovidDeaths.iso_code
where total_vaccinations is not null and total_vaccinations <> 0
ORDER BY 1,2

ALTER TABLE CovidVaccinations
ALTER COLUMN new_vaccinations numeric

SELECT * FROM CovidVaccinations
WHERE location='philippines'
ORDER BY 1,2

SELECT* from CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
ORDER BY dea.location,dea.date

dea.location,dea.date,population,new_cases,new_vaccinations, total_vaccinations, positive_rate

--Total Population vs Vaccination per country
SELECT dea.continent,dea.location, dea.date,population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
ORDER BY 2,3

--USE CTE

WITH popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location, dea.date,population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 as PercentVaccinated
FROM popvsvac

-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(continent varchar(255),
location varchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date,population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
--ORDER BY 2,3
SELECT *, (RollingPeopleVaccinated/population)*100 as PercentVaccinated
FROM #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER FOR VISUALIZATION

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent,dea.location, dea.date,population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
--ORDER BY 2,3
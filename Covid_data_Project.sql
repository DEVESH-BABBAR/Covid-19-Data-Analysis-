
SELECT *
from [Covid Project]..death$
where continent is not null
order by 3,4

SELECT *
from [Covid Project]..vaccination$
where continent is not null
order by 3,4

select location, date , total_cases, new_cases, total_deaths, population
from [Covid Project]..death$
where continent is not null
order by 1,2

select location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Covid Project]..death$
where location like 'india'
and continent is not null
order by 1,2

select location, date , total_cases, population , (total_cases/population)*100 as Positivecases
from [Covid Project]..death$
where location like 'india'
and continent is not null
order by 1,2
create view tableau3 as 
select location , population, max(total_cases) as Highestpositivecases ,max((total_cases/population))*100 as Positivecases
from [Covid Project]..death$
where continent is not null
group by location, population
order by Positivecases desc

select location , max(cast(total_deaths as int)) as Highest_death_Count, population , max((total_deaths/population))*100 as deaths_cases
from [Covid Project]..death$
where continent is not null
group by location, population
order by 3,4

select continent, max(cast(total_deaths as int)) as Highest_death_Count
from [Covid Project]..death$
where continent is not null
group by continent
order by highest_death_count desc


select continent, max(cast(total_deaths as int)) as Highest_death_Count
from [Covid Project]..death$
where continent is not null
group by continent
order by highest_death_count 

select date,sum(new_cases) as total_cases-- total_cases, total_deaths, (total_cases/population)*100 as Positivecases
from [Covid Project]..death$
--where location like 'india'
where continent is not null
group by date
order by 1,2


select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Covid Project]..death$
--where location like 'india'
where continent is not null

group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Covid Project]..death$
--where location like 'india'
where continent is not null
--group by date
order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by DEA.LOCATION) 
from [Covid Project]..vaccination$ vac
join [Covid Project]..death$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


with popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint , vac.new_vaccinations)) OVER (Partition by DEA.LOCATION order by dea.location,dea.date) as rolling_people_vaccinated
--,(rolling_people_vaccinated/dea.population)*100
from [Covid Project]..vaccination$ vac
join [Covid Project]..death$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (rolling_people_vaccinated/population)*100 as rolling_people_Percentage
from popvsvac





drop table if exists #percenteagepeoplevaccinated
create table #percenteagepeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rolling_people_vaccinated numeric
)

insert into #percenteagepeoplevaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint , vac.new_vaccinations)) OVER (Partition by DEA.LOCATION order by dea.location,dea.date) as rolling_people_vaccinated
--,(rolling_people_vaccinated/dea.population)*100
from [Covid Project]..vaccination$ vac
join [Covid Project]..death$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*, (rolling_people_vaccinated/population)*100 as rolling_people_Percentage
from #percenteagepeoplevaccinated


create view percenteagepeoplevaccinated1 as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(bigint , vac.new_vaccinations)) OVER (Partition by DEA.LOCATION order by dea.location,dea.date) as rolling_people_vaccinated
--,(rolling_people_vaccinated/dea.population)*100
from [Covid Project]..vaccination$ vac
join [Covid Project]..death$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

--GRAPHS 1


create view tableau1 as
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Covid Project]..death$
--where location like 'india'
where continent is not null
--group by date
--order by 1,2

select*
from tableau1

--2
create view tableau2_0 as
select location , sum(cast(total_deaths as int)) as total_death_count-- population , max((total_deaths/population))*100 as deaths_cases
from [Covid Project]..death$
where continent is null and 
location not in ('world','europe union','internantional')
group by location
--order by total_death_count desc


select*
from tableau2

--3
select location , population,max(total_cases) as Highestpositivecases ,max((total_cases/population))*100 as Positivecases
from [Covid Project]..death$
where continent is not null
group by location, population
order by Positivecases desc


--4


create view tableau5 as 
select location , population , date ,max(total_cases) as Highestpositivecases ,max((total_cases/population))*100 as Positivecases
from [Covid Project]..death$
--where continent is not null
group by location, population,date
--order by Positivecases desc

select*
from tableau5
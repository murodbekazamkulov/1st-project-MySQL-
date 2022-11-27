use covid_case; 

-- 1st query: joining covid_cases_1 with total_cases_death
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    total.total_cases,
    total.total_deaths
FROM
    covid_cases_1 co
        JOIN
    total_cases_death total ON co.country_no = total.country_no
ORDER BY co.country_no; 

-- 2nd query: joining covid_cases_1 with daily_cases_deaths 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    da.daily_cases,
    da.daily_deaths
FROM
    covid_cases_1 co
        JOIN
    daily_cases_deaths da ON co.country_no = da.country_no
ORDER BY co.country_no;  

-- 3rd query: joining 3 tables, covid_case_1, fully_total_vaccination and daily_people_vaccination 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    ful.fully_vaccinated,
    ful.total_vaccinations,
    ful.total_boosters,
    dai.daily_vaccinations,
    dai.daily_people_vaccinated
FROM
    covid_cases_1 co
        JOIN
    fully_total_vaccinations ful ON co.country_no = ful.country_no
        JOIN
    daily_people_vaccinations dai ON co.country_no = dai.country_no
ORDER BY co.country_no; 

-- 4th query: joining all 5 tables, covid_case_1, fully_total_vaccination and daily_people_vaccination, 
-- total_cases_death, daily_cases_deaths 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    ful.fully_vaccinated,
    ful.total_vaccinations,
    ful.total_boosters,
    dai.daily_vaccinations,
    dai.daily_people_vaccinated,
    total.total_cases,
    total.total_deaths,
    da.daily_cases,
    da.daily_deaths
FROM
    covid_cases_1 co
        JOIN
    fully_total_vaccinations ful ON co.country_no = ful.country_no
        JOIN
    daily_people_vaccinations dai ON co.country_no = dai.country_no
        JOIN
    total_cases_death total ON co.country_no = total.country_no
        JOIN
    daily_cases_deaths da ON co.country_no = da.country_no
ORDER BY co.country_no; 

-- 5th query joining all tables only for South Korea case 
select co.country_no, co.to_country, co.to_date, ful.fully_vaccinated, ful.total_vaccinations, ful.total_boosters, 
dai.daily_vaccinations, dai.daily_people_vaccinated, total.total_cases, total.total_deaths, da.daily_cases, da.daily_deaths
from covid_cases_1 co 
join fully_total_vaccinations ful on co.country_no = ful.country_no 
join daily_people_vaccinations dai on co.country_no = dai.country_no 
join total_cases_death total on co.country_no = total.country_no 
join daily_cases_deaths da on co.country_no = da.country_no 
where to_country = 'south korea'
order by co.country_no; 

-- 6th query joining joining covid_cases_1 with total_cases_death, 
-- and comparing South Korea vs China with less than 700 total_deaths and limit 300 rows
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    total.total_cases,
    total.total_deaths
FROM
    covid_cases_1 co
        JOIN
    total_cases_death total ON co.country_no = total.country_no
WHERE
    to_country IN ('south korea' , 'china')
        AND total_deaths <= '700'
ORDER BY total.total_deaths DESC
LIMIT 300; 

-- 7th query joining joining covid_cases_1 with total_cases_death, 
-- and comparing South Korea vs China with less than 700 total_deaths and limit 300 rows. 
-- (Less than 700 total_deaths showed in average and maximum) 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    total.total_cases,
    AVG(total.total_deaths) AS average_deaths,
    MAX(total.total_deaths) AS maximum_deaths
FROM
    covid_cases_1 co
        JOIN
    total_cases_death total ON co.country_no = total.country_no
WHERE
    to_country IN ('south korea' , 'china')
        AND total_deaths <= '700'
GROUP BY co.country_no , co.to_country , co.to_date , total.total_cases , total.total_deaths
ORDER BY total.total_deaths DESC
LIMIT 300; 

-- 8th query joining joining co.country_no, co.to_country, co.to_date, ful.fully_vaccinated, ful.total_vaccinations, 
-- ful.total_boosters, dai.daily_vaccinations, dai.daily_people_vaccinated, total.total_cases, total.total_deaths, 
-- total.total_deaths, da.daily_cases, da.daily_deaths, and comparing all world with less than 700 total_deaths and limit 300 rows. 
-- (Less than 700 total_deaths showed in average and maximum) 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    ful.fully_vaccinated,
    ful.total_vaccinations,
    ful.total_boosters,
    dai.daily_vaccinations,
    dai.daily_people_vaccinated,
    total.total_cases,
    AVG(total.total_deaths) AS average_deaths,
    MAX(total.total_deaths) AS maximum_deaths,
    da.daily_cases,
    da.daily_deaths
FROM
    covid_cases_1 co
        JOIN
    fully_total_vaccinations ful ON co.country_no = ful.country_no
        JOIN
    daily_people_vaccinations dai ON co.country_no = dai.country_no
        JOIN
    total_cases_death total ON co.country_no = total.country_no
        JOIN
    daily_cases_deaths da ON co.country_no = da.country_no
WHERE
    total_deaths <= '700'
GROUP BY co.country_no , co.to_country , co.to_date , ful.fully_vaccinated , ful.total_vaccinations , ful.total_boosters , dai.daily_vaccinations , dai.daily_people_vaccinated , total.total_cases , total.total_deaths , da.daily_cases , da.daily_deaths
ORDER BY co.country_no
LIMIT 300;  

-- 9th query create or replace view (total_cases_death) 
CREATE OR REPLACE VIEW t_total_cases_death AS
    SELECT 
        country_no,
        MAX(total_cases) AS total_cases,
        MAX(total_deaths) AS total_death
    FROM
        total_cases_death
    GROUP BY country_no; 
    
-- 10th query joining joining co.country_no, co.to_country, co.to_date, total.total_deaths, da.daily_deaths, 
-- and comparing all world with less than 700 total_deaths and limit 300 rows. 
-- (Less than 700 total_deaths and daily_deaths showed in average and maximum) 
SELECT 
    co.country_no,
    co.to_country,
    co.to_date,
    AVG(total.total_deaths) AS average_deaths,
    MAX(total.total_deaths) AS maximum_deaths,
    AVG(da.daily_deaths) AS avg_daily_deaths,
    MAX(da.daily_deaths) AS max_daily_deaths
FROM
    covid_cases_1 co
        JOIN
    total_cases_death total ON co.country_no = total.country_no
        JOIN
    daily_cases_deaths da ON co.country_no = da.country_no
WHERE
    total_deaths <= '700'
GROUP BY co.country_no , co.to_country , co.to_date , total.total_deaths , da.daily_deaths
ORDER BY co.country_no
LIMIT 300; 

-- 11th query create procedure joining covid_cases_1 with total_cases_death, 
-- and comparing South Korea vs China with less than 700 total_deaths and limit 300 rows. 
-- (Less than 700 total_deaths showed in average and maximum) 
use covid_case; 
drop procedure if exists select_fully_total_vaccinations; 
delimiter $$ 
create procedure select_fully_total_vaccinations ()
begin
SELECT co.country_no, co.to_country, co.to_date, total.total_cases, avg(total.total_deaths) as average_deaths, 
max(total.total_deaths) as maximum_deaths
from covid_cases_1 co 
join total_cases_death total on co.country_no = total.country_no 
where to_country in('south korea', 'china') and total_deaths <= '700' 
group by co.country_no, co.to_country, co.to_date, total.total_cases, total.total_deaths
order by total.total_deaths desc 
limit 300;  
end$$ 














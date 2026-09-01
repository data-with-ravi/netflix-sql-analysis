USE netflix_project;





CREATE TABLE netflix_titles (
    show_id int,
    type varchar(200),
    title varchar(200),
    director varchar(200),
    cast varchar(1000),
    country varchar(200),
    date_added varchar(30),
    release_year int,
    rating text,
    duration text,
    listed_in text,
    description text
);


show tables;

USE netflix_project;

LOAD DATA LOCAL INFILE 'C:/SQL learning/netflix_titles.csv'
INTO TABLE netflix_titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) as total_rows
from netflix_titles;

describe netflix_titles;

select date_added, rating, director, country, duration
from netflix_titles
limit 10;

alter table netflix_titles
modify column date_added varchar(300);

describe netflix_titles;

drop table netflix_titles;

select date_added from netflix_titles
limit 10;

select type, count(*) as total_titles
from netflix_titles
group by type;

select type, count(*) as total_titles,
round(count(*) * 100 / (select count(*) from netflix_titles), 2) as percentage
from netflix_titles
group by type
order by total_titles;

select release_year, count(*) as total_titles
from netflix_titles
where type = 'Movie'
group by release_year
order by total_titles desc
limit 10;


select rating, count(*) as total_titles
from netflix_titles
group by rating
order by total_titles desc
limit 5;

select country, count(*) as total_titles
from netflix_titles
where country is not null
and country <> ''
group by country
order by total_titles desc
limit 10;

select type, country,
count(*) as total_titles
from netflix_titles
where country is not null
and country <> ''
group by type, country
order by total_titles desc
limit 10;

select type, release_year,
count(*) as total_titles
from netflix_titles
group by type, release_year
order by total_titles desc
limit 10;

#select date_added, count(*) as total_titles
#from netflix_titles


SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS added_year,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND date_added <> ''
GROUP BY added_year
ORDER BY added_year DESC;

select type,
 year(str_to_date(date_added, '%m %d, %y')) as added_year,
 count(*) as total_titles
 from netflix_titles
 where date_added is not null
 and trim(date_added) <> ''
group by type, added_year
order by total_titles desc;

SELECT date_added
FROM netflix_titles
WHERE date_added <> ''
LIMIT 1;


SELECT 
    type,
    YEAR(STR_TO_DATE(TRIM(date_added), '%M %d, %Y')) AS added_year,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND TRIM(date_added) <> ''
GROUP BY type, added_year
ORDER BY added_year DESC;

select duration, count(*) as total_titles
from netflix_titles
where type = 'Movie'
and duration <> ''
group by duration
order by total_titles desc
limit 10;

select title, duration,
cast(substring_index(duration, ' ', 1) as unsigned) as minutes
from netflix_titles
where type = 'Movie'
and duration is not null
and duration <> ''
order by minutes desc
limit 5;

select 
avg(cast(trim(substring_index(duration, ' ', 1))as unsigned)) as minutes
from netflix_titles
where type = 'Movie'
and duration is not null
and duration <> ''
order by minutes desc;

select rating, count(*) as total_titles
from netflix_titles
where type = 'TV Show'
group by rating
order by total_titles desc
limit 5;


select 
AVG(CAST(TRIM(SUBSTRING_INDEX(duration, ' ', 1)) AS UNSIGNED)) as  avg_seasons
from netflix_titles
where type = 'TV Show'
and duration is not null
and duration <> ''
order by avg_seasons desc;

select rating, release_year, count(*) as total_titles
from netflix_titles
where type = 'Movie'
and rating is not null
and rating <> ''
group by rating, release_year
order by total_titles desc
limit 10;

select director, count(*) as total_titles
from netflix_titles
where director is not null
and director <> ''
group by director
order by total_titles desc
limit 10;

SELECT cast
FROM netflix_titles
WHERE cast IS NOT NULL
  AND cast <> ''
LIMIT 5;
use netflix_project;
with recursive actor_split as (
select 
trim(substring_index(cast, ',', 1)) as actor,
substring(cast, length(substring_index(cast, ',', 1)) +2) as remaining
from netflix_titles
where cast is not null
and cast <> ''
union all

select
trim(substring_index(remaining, ',', 1)) as actor,
substring(remaining, length(substring_index(remaining, ',', 1)) +2) as remaining
from actor_split
where remaining <> ''
)
select actor, count(*) as total_titles
from actor_split
where actor <> ''
group by actor
order by total_titles desc
limit 30;


with recursive country_split as (
select
type,
trim(substring_index(country, ',', 1)) as country,
substring(country, length(substring_index(country, ',', 1)) +2) as remaining
from netflix_titles
where country is not null
and country <> ''
union all

select type,
trim(substring_index(remaining, ',', 1)) as country,
substring(remaining, length(substring_index(remaining, ',', 1)) +2) 
from country_split
where remaining is not null 
and remaining <> ''
)
select type, country, count(*) as total_titles
from country_split
where country is not null
and country <> ''
group by country, type
order by total_titles desc
limit 10;



select type,release_year, count(*) as total_titles
from netflix_titles
group by release_year, type
order by total_titles desc
limit 10;

with recursive split_genrie as (
select type,
trim(substring_index(listed_in, ',', 1)) as listed_in,
substring(listed_in, length(substring_index(listed_in, ',', 1)) +2) as remaining
from netflix_titles
where type = 'TV Show' and  listed_in is not null
and listed_in <> ''
union all
select type,
trim(substring_index(remaining, ',', 1)) as listed_in,
substring(remaining, length(substring_index(remaining, ',', 1)) +2) as remaining
from split_genrie
where type = 'TV Show' and remaining is not null
and remaining <> ''
)
select listed_in, type, count(*) as total_titles
from split_genrie
where type = 'TV Show'
group by listed_in , type
order by total_titles desc
limit 10;


select type, count(*) as total_titles,
round(count(*) * 100.0 / (select count(*) from netflix_titles), 2) as percentage
from netflix_titles
group by type
order by percentage desc;

select rating, count(*) as total_titles
from netflix_titles
where rating is not null 
and rating <> ''
group by rating
order by total_titles desc
limit 5;

select
min(release_year) as min_year,
 max(release_year) as max_year,
 count(*) as total_titles
from netflix_titles
order by total_titles desc;


select 
year(str_to_date(date_added, '%m %d, %y')) as added_year,
count(*) as total_titles
from netflix_titles
where date_added is not null
and date_added <> ''
group by added_year
order by total_titles desc
limit 10;



SELECT
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS added_year,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND date_added <> ''
GROUP BY added_year
ORDER BY total_titles DESC
LIMIT 10;


select director, count(*) as total_titles
from netflix_titles
where type = 'TV Show'
and director is not null
and director <> ''
group by director
order by total_titles desc
limit 10;


select 
avg(cast(trim(substring_index(duration, ' ', 1)) as unsigned)) as avg_duration,
count(*) as total_titles
from netflix_titles
where type = 'Movie'
and duration is not null
and duration <> ''
group by duration
order by total_titles desc;

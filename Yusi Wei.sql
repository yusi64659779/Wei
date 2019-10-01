--Display each beer’s name and style name.  
--A beer should be displayed regardless of whether a style name exists or not.
select beer_name, style_name
from beers left outer join styles
on beers.style_id=styles.style_id;

--Display each beer’s name, category name, color example, and style name, 
--for all beers that have values for category name, color example, and style name.
select beer_name, category_name, examples, style_name 
from beers Inner join categories 
on categories.category_id= beers.cat_id 
Inner join colors 
on colors.lovibond_srm= beers.srm 
Inner join styles 
on styles.style_id= beers.style_id;

--Display each brewer’s name along with the minimum, maximum, and average alcohol by volume (ABV) of its beers.  
--Exclude any beers with an ABV of zero.  
--Show the brewers with the highest average ABV first.
select name as brewery_name, min(ABV), max(ABV), avg(ABV)
from breweries NATURAL join beers
where beers.abv!=0
group by name
order by avg(ABV) DESC;

--Find which cities would be good for hosting microbrewery tours. A city must have at least 10 breweries to be considered.  
--Display the city's name as well as how many breweries are in the city.  
--Show cities with the most breweries first.
select city, count(brewery_id)
from breweries natural join beers
group by city
having count(brewery_id)>=10
order by count(brewery_id) DESC;

--Display all beer names that (1) belong to a category with a name containing “Lager” somewhere in the name and 
--(2) have an alcohol by volume (ABV) of eight or greater.  
--Show the beer names in alphabetical order.
select beer_name
from beers inner join categories
on beers.cat_id=categories.category_id
where category_name like '%Lager%' and ABV>=8
order by beer_name ASC;

--Display the name of all movies that have an IMDB rating of at least 8.0, with more than 100,000 IMDB votes, 
--and were released from 2007 to 2013.  
--Show the movies with the highest IMDB ratings first.
select film_title,imdb_rating
from movies
where imdb_rating>=8.0 and imdb_votes>100000 and film_year between 2007 and 2013
order by imdb_rating DESC;

--Display each movie’s title and total gross, where total gross is USA gross and worldwide gross combined. 
--Exclude any movies that do not have values for either USA gross or worldwide gross.  
--Show the highest grossing movies first.
select film_title, usa_gross+worldwide_gross as total_gross
from movies
where usa_gross!=0 and worldwide_gross!=0
order by total_gross DESC;

--Display the titles of any movies where Tom Hanks or Tim Allen were cast members. 
--Each movie title should be shown only once.
select distinct film_title
from movies inner join casts
on movies.film_id=casts.film_id
where casts.cast_member like 'Tom Hanks' or casts.cast_member like 'Tim Allen';

--Display the number of movies with an MPAA rating of G, PG, PG-13, and R.  
--Show the results in alphabetical order by MPAA rating.
select count(film_title),mpaa_rating
from movies 
where mpaa_rating in ('G', 'PG', 'PG-13','R')
group by mpaa_rating
order by mpaa_rating ASC;

--Label the strength of a beer based on its ABV.  
--For each beer display the beer's name, ABV, and a textual label describing the strength of the beer. 
--The label should be "Very High" for an ABV more than 10, "High" for an ABV of 6 to 10, "Average" for an ABV of 3 to 6, and "Low" for an ABV less than 3.  
--Show the records by beer name.
select beer_name,abv,
case when abv > 10 then 'Very High'
  when abv between 6 and 10 then 'High'
  when abv between 3 and 6 then 'Average'
else 'Low'
end as Strength
from beers;

--Find all breweries that specialize in a particular beer style.  
--A brewer is considered specialized if they produce at least 10 beers from the same style.  
--Show the brewer's name, style name, and how many beers the brewer makes of that style.  
--Display the records by style name first and then by breweries with the most beers within that style.
select style_name, name as brewery_name, count(beer_id)
from breweries inner join beers 
on breweries.brewery_id=beers.brewery_id 
inner join styles
on beers.style_id=styles.style_id
group by style_name,name
having count(beer_id)>=10
order by count(beer_id) desc;

--Display each brewer’s name and how many beers they have associated with their brewery.  
--Only include brewers that are located outside the United States 
--and have more than the average number of beers from all breweries (excluding itself when calculating the average).  
--Show the brewers with the most beers first.  If there is a tie in number of beers, then sort by the brewers’ names.
SELECT br.brewery_id, br.name, count(beer_id) as "Number of beers" 
FROM beerdb.beers be INNER JOIN beerdb.breweries br 
ON (be.brewery_id = br.brewery_id)
WHERE country NOT LIKE 'United States' 
GROUP BY br.name, br.brewery_id 
HAVING COUNT(*) > (SELECT avg(count(*)) 
                   FROM beerdb.beers be1 
                   WHERE be1.brewery_id <> br.brewery_id 
                   GROUP BY be1.brewery_id, br.brewery_id)
ORDER BY COUNT(*) desc, br.name;
                  
--For each movie display its movie title, year, and how many cast members were a part of the movie.  
--Exclude movies with five or fewer cast members.  
--Display movies with the most cast members first, followed by movie year and title.
select count(cast_member),film_year,film_title
from movies natural join casts
group by film_title,film_year
having count(cast_member)>5
order by count(cast_member) desc;

--For each genre display the total number of films, average fan rating, and average USA gross.  
--A genre should only be shown if it has at least five films.  
--Any film without a USA gross should be excluded.  
--A film should be included regardless of whether any fans have rated the film.  
--Show the results by genre.  (Hint: use the TRIM function to only show a single record from the same genre.)
select count(GENRES.FILM_ID),AVG(IMDB_RATING),AVG(USA_GROSS),Genre
from GENRES INNER JOIN MOVIES
on(GENRES.FILM_ID=MOVIES.FILM_ID)
where (USA_GROSS is not NULL)
group by Genre having Count(GENRES.FILM_ID)>=5;

--Find the average budget for all films from a director with at least one movie in the top 25 IMDB ranked films.  
--Show the director with the highest average budget first.
select avg(budget),director
from movies natural join directors
where director in (select director
                    from movies natural join directors
                    where imdb_rank<=25)
group by director
order by avg(budget) desc;

--Find all duplicate fans.  
--A fan is considered duplicate if they have the same first name, last name, city, state, zip, and birth date.
select fname, lname, city, state, zip, birth_day
from fans
group by fname, lname, city, state, zip, birth_day
having count(*)>1;

--We believe there may be erroneous data in the movie database.  
--To help uncover unusual records for manual review, 
--write a query that finds all actors/actresses with a career spanning 60 years or more. 
--Display each actor's name, how many films they worked on, 
--the year of the earliest and latest film they worked on, 
--and the number of years the actor was active in the film industry 
--(assume all years between the first and last film were active years).  Display actors with the longest career first.
select cast_member,count(film_id),min(film_year),max(film_year), max(film_year)-min(film_year)
from movies mov1 natural join casts cast1
where cast_member in (select cast_member
                      from movies mov2 natural join casts cast2
                      where cast1.cast_member=cast2.cast_member)
group by cast_member
having max(film_year)-min(film_year)>=60
order by max(film_year)-min(film_year) desc;


     



--new
--find all breweries where the number of beers is greater than the average of the total number of beers at all breweries
with num_of_beer (brewery_id, name, value) 
as (select brewery_id, name, count(beer_id) 
    from breweries natural join beers 
    group by brewery_id, name), 
avg_of_beer(value) 
as (select avg(value) 
    from num_of_beer) 
select brewery_id,name as brewery_name
from num_of_beer, avg_of_beer 
where num_of_beer.value >=avg_of_beer.value;

--Rank beers in descending order by their alcohol by volume (ABV) content.  
--Only consider beers with an ABV greater than zero.
--Display the rank number, beer name, and ABV for all beers ranked 1-10. 
--Do not leave any gaps in the ranking sequence when there are ties (e.g., 1, 2, 2, 2, 3, 4, 4, 5). 
--(Hint: derived tables may help with this query.)
select beer_name, abv,
DENSE_RANK() OVER (ORDER BY abv desc) AS RANK_NUMBER
from beers
where abv>0

--Display the film title, film year and worldwide gross for all movies directed by Christopher Nolan that have a worldwide gross greater than zero.  
--In addition, each row should contain the cumulative worldwide gross 
--(current row's worldwide gross plus the sum of all previous rows' worldwide gross).  
--Records should be sorted in ascending order by film year.
select film_title, film_year, worldwide_gross,worldwide_gross+(select sum(worldwide_gross)
                                                                from movies mov2
                                                                where mov1.film_id<mov2.film_id) as cumulative_worldwide_gross 
from movies mov1 inner join directors dir1
on mov1.film_id=dir1.film_id
where director = 'Christopher Nolan' and worldwide_gross>0
order by film_year

--Assign breweries to groups based on the number of beers they brew.  
--Display the brewery ID, name, number of beers they brew, and group number for each brewery.  
--The group number should range from 1 to 4, 
--with group 1 representing the top 25% of breweries (in terms of number of beers), 
--group 2 representing the next 25% of breweries, group 3 the next 25%, and group 4 for the last 25%.  
--Breweries with the most beers should be shown first.  In the case of a tie, show breweries by brewery ID (lowest to highest).
select brewery_ID, name, count(beer_id), ntile(4)over(order by count(beer_id) desc) as 'Group_NO'
from breweries inner join beers
on breweries.brewery_id=beers.brewery_id
group by brewery_ID, name
order by brewery_ID;

(select fname,lname
 from relmdb.FANS)
 minus
(select fname,lname
 from relmdb.FANS_OLD)

select film_year, film_title, runtime, rank() OVER (ORDER BY (runtime) DESC) 
from (select film_year, film_title, runtime
      from movies
      where film_year<=1999 and runtime>0)
      




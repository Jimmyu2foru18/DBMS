--James McGuigan DBMS Project 1 9-20-24

--Q1 write a SQL query to list the titles of all movies released in 2008.
--Your query should output a table with a single column for the title of each movie.
SELECT title FROM movies
WHERE year = 2008;

--Q2, write a SQL query to determine the birth year of Emma Stone.
--Your query should output a table with a single column and a single row (plus optional header) containing Emma Stone’s birth year.
--You may assume that there is only one person in the database with the name Emma Stone.
SELECT birth AS birth_year FROM people
WHERE name = 'Emma Stone';

--Q3 write a SQL query to list the titles of all movies with a release date on or after 2018, in alphabetical order.
--Your query should output a table with a single column for the title of each movie.
--Movies released in 2018 should be included, as should movies with release dates in the future
SELECT title FROM movies
WHERE year >= 2018
ORDER BY title;

--Q4 write a SQL query to list the titles and release years of all Harry Potter movies, in chronological order.
--Your query should output a table with two columns, one for the title of each movie and one for the release year of each movie.
--You may assume that the title of all Harry Potter movies will begin with the words “Harry Potter”, and that if a movie title begins with the words “Harry Potter”, it is a Harry Potter movie.
SELECT title, year FROM movies
WHERE title LIKE 'Harry Potter%'
ORDER BY year;

--Q5, write a SQL query to determine the number of movies with an IMDb rating of 10.0.
--Your query should output a table with a single column and a single row (plus optional header) containing the number of movies with a 10.0 rating.
SELECT COUNT(*) AS number_of_movies FROM ratings
WHERE rating = 10.0;

--Q6, write a SQL query to determine the average rating of all movies released in 2012.
--Your query should output a table with a single column and a single row (plus optional header) containing the average rating.
SELECT AVG(r.rating) AS average_rating FROM ratings r
JOIN movies m ON r.movie_id = m.id
WHERE m.year = 2012;

--Q7, write a SQL query to list all movies released in 2010 and their ratings, in descending order by rating. For movies with the same rating, order them alphabetically by title.
--Your query should output a table with two columns, one for the title of each movie and one for the rating of each movie.
--Movies that do not have ratings should not be included in the result.
SELECT m.title, r.rating FROM movies m
JOIN ratings r ON m.id = r.movie_id
WHERE m.year = 2010
ORDER BY r.rating DESC, m.title;

--Q8, write a SQL query to list the names of all people who starred in Toy Story.
--Your query should output a table with a single column for the name of each person.
--You may assume that there is only one movie in the database with the title Toy Story.
SELECT p.name FROM stars s
JOIN people p ON s.person_id = p.id
JOIN movies m ON s.movie_id = m.id
WHERE m.title = 'Toy Story';

--Q9, write a SQL query to list the names of all people who starred in a movie released in 2004, ordered by birth year.
--Your query should output a table with a single column for the name of each person.
--People with the same birth year may be listed in any order.
--No need to worry about people who have no birth year listed, so long as those who do have a birth year are listed in order.
--If a person appeared in more than one movie in 2004, they should only appear in your results once.
SELECT p.name FROM stars s
JOIN movies m ON s.movie_id = m.id
JOIN people p ON s.person_id = p.id
WHERE m.year = 2004
GROUP BY p.name, p.birth
ORDER BY p.birth; 

--Q10, write a SQL query to list the names of all people who have directed a movie that received a rating of at least 9.0.
--Your query should output a table with a single column for the name of each person.
SELECT DISTINCT p.name FROM directors d
JOIN movies m ON d.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
JOIN people p ON d.person_id = p.id
WHERE r.rating >= 9.0;

--Q11, write a SQL query to list the titles of the five highest rated movies (in order) that Chadwick Boseman starred in, starting with the highest rated.
--Your query should output a table with a single column for the title of each movie.
--You may assume that there is only one person in the database with the name Chadwick Boseman.
SELECT m.title FROM stars s
JOIN movies m ON s.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE s.person_id = (SELECT id FROM people WHERE name = 'Chadwick Boseman')
ORDER BY r.rating DESC
LIMIT 5;

--Q12, write a SQL query to list the titles of all movies in which both Johnny Depp and Helena Bonham Carter starred.
--Your query should output a table with a single column for the title of each movie.
--You may assume that there is only one person in the database with the name Johnny Depp.
--You may assume that there is only one person in the database with the name Helena Bonham Carter.
SELECT m.title FROM stars s1
JOIN stars s2 ON s1.movie_id = s2.movie_id
JOIN movies m ON s1.movie_id = m.id
WHERE s1.person_id = (SELECT id FROM people WHERE name = 'Johnny Depp')
AND s2.person_id = (SELECT id FROM people WHERE name = 'Helena Bonham Carter');

--Q13, write a SQL query to list the names of all people who starred in a movie in which Kevin Bacon also starred.
--Your query should output a table with a single column for the name of each person.
--There may be multiple people named Kevin Bacon in the database. Be sure to only select the Kevin Bacon born in 1958.
--Kevin Bacon himself should not be included in the resulting list.
SELECT DISTINCT p.name FROM stars s
JOIN stars s2 ON s.movie_id = s2.movie_id
JOIN people p ON s2.person_id = p.id
WHERE s.person_id = (SELECT id FROM people WHERE name = 'Kevin Bacon' AND birth = 1958)
AND p.id != (SELECT id FROM people WHERE name = 'Kevin Bacon' AND birth = 1958);

--Q14 write a SQL query to find all the movies that are better than the average ratings.
SELECT m.title FROM movies m
JOIN ratings r ON m.id = r.movie_id
WHERE r.rating > (SELECT AVG(r2.rating) FROM ratings r2);

--Q15 Write a SQL query to find the average rating for each co-stars.
SELECT p.name, AVG(r.rating) AS average_rating FROM stars s
JOIN movies m ON s.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
JOIN people p ON s.person_id = p.id
GROUP BY p.name;

--Q 16 Write a SQL query that returns the highest and the lowest rated movies for each actor, sort by the difference in ratings.
SELECT p.name, MAX(r.rating) AS highest_rating, MIN(r.rating) AS lowest_rating FROM stars s
JOIN movies m ON s.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
JOIN people p ON s.person_id = p.id
GROUP BY p.name
ORDER BY (MAX(r.rating) - MIN(r.rating)) DESC;

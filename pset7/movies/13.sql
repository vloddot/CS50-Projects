SELECT DISTINCT(people.name)
FROM people
INNER JOIN stars
ON people.id = stars.person_id
WHERE stars.movie_id IN (
    SELECT stars.movie_id
    FROM people
    INNER JOIN stars
    ON people.id = stars.person_id
    WHERE people.name = "Kevin Bacon"
    AND people.birth = 1958
)
AND people.name != "Kevin Bacon";
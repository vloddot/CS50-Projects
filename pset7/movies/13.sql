SELECT people.name
FROM people
WHERE people.id IN (
    SELECT stars.person_id
    FROM stars
    JOIN people ON people.id = stars.person_id
    WHERE stars.person_id IN (
        SELECT people.id
        FROM people
        JOIN stars ON people.id = stars.person_id
        WHERE people.name = "Kevin Bacon"
        OR stars.person_id IN (
            SELECT people.id
            FROM people
            WHERE people.name != "Kevin Bacon"
        )
    )
);

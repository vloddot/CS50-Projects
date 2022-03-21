-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Notes
-- Theft happened on 28/7 10:15 am
-- Within ten minutes of the theft, the thief got into a car in the bakery parking lot and drove away
-- Possible license plate numbers: L93JTIZ, 322W7JE, 0NTHK55
-- Someone was walking by an ATM on Leggett Street and saw the thief withdrawing some money
-- As the thief left the bakery, they called someone who talked to them for less than a minute. (witnesses heard him saying that they were planning to take the earliest flight out of Fiftyville tomorrow then he asked the person on the other end to purchase the flight ticket)
-- The thief most likely went to NYC the day after the theft
-- Possible times for flight 8:20, 9:30, 12:15, 15:20, 16:00
-- Thief is Bruce because he called someone in the bakery for less than 60 seconds and exited the bakery between 10:15am and 10:25am and also occurs multiple times in a lot of queries like the ATM transaction
-- 

-- Description of theft.
SELECT description
FROM crime_scene_reports
WHERE month = 7 
AND day = 28
AND street = "Humphrey Street";

-- Interview transcripts
SELECT transcript
FROM interviews
WHERE month = 7
AND day = 28
AND id = 161
OR id = 162
OR id = 163;

-- Bakery security logs
SELECT activity, license_plate, minute 
FROM bakery_security_logs
WHERE month = 7 
AND day = 28 
AND hour = 10;

-- Information for possible license plate numbers
SELECT *
FROM people
WHERE license_plate = 'L93JTIZ'
OR license_plate = '322W7JE'
OR license_plate = '0NTHK55';

-- Phone calls on 28th of July, 2021
SELECT caller, receiver, duration
FROM phone_calls
WHERE month = 7
AND day = 28
AND duration < 60;

-- Names of people who made phone calls less than 60 seconds on the 28th of July, 2021
SELECT name
FROM people
JOIN phone_calls
ON phone_calls.caller = people.phone_number
WHERE day = 28
AND month = 7
AND year = 2021
AND duration <= 60

-- Airport information
SELECT id, full_name, city, abbreviation
FROM airports;

-- Information for flight passengers
SELECT *
FROM passengers;

-- Flight information for the day after the theft
SELECT flights.id, flights.origin_airport_id, flights.destination_airport_id, flights.minute, airports.abbreviation
FROM flights
JOIN airports
ON flights.origin_airport_id = airports.id
WHERE month = 7
AND day = 29;

-- Information on bank accounts the day and location of the ATM transaction
SELECT *
FROM bank_accounts
WHERE account_number IN (
    SELECT account_number
    FROM atm_transactions
    WHERE month = 7
    AND day = 28
    AND atm_location = 'Leggett Street'
    AND transaction_type = 'withdraw'
);

-- People who have withdrawn on Leggget Street on 28th of July
SELECT name
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
JOIN atm_transactions
ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type = "withdraw";

-- Names of people who have flown on the day after the incident
SELECT name
FROM people
JOIN passengers
ON people.passport_number = passengers.passport_number
WHERE passengers.flight_id IN (
    SELECT id
    FROM flights
    WHERE origin_airport_id IN (
        SELECT id
        FROM airports
        WHERE city = "Fiftyville"
    )
    -- Order by hour and minute to take the earliest flights
    ORDER BY hour, minute
    -- Limit to one flight (not one passenger)
    LIMIT 1
);

-- The ATM transactions on 28th of July, 2021 and on Leggett Street
SELECT *
FROM atm_transactions
WHERE month = 7
AND day = 28
AND atm_location = 'Leggett Street';

-- Suspects exiting the bakery from 10:15am to 10:25am (using license plates)
SELECT name
FROM people
JOIN bakery_security_logs
ON bakery_security_logs.license_plate = people.license_plate
WHERE year = 2021
AND month = 7
AND day = 28
AND hour = 10
AND minute >= 15
AND minute <= 25
AND bakery_security_logs.activity = 'exit';

-- Bruce's phone number (the thief): (367) 555-5533

-- The accomplice
SELECT name
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.receiver
WHERE phone_calls.caller = "(367) 555-5533"
AND phone_calls.year = 2021
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration < 60


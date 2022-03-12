-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Description of theft.
SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = "Humphrey Street";

-- Interview transcript
SELECT transcript
FROM interviews
WHERE month = 7 AND day = 28 AND id = 161 OR id = 162 OR id = 163;

-- Bakery security logs
SELECT activity, license_plate, minute FROM bakery_security_logs
WHERE month = 7 AND day = 28 AND hour = 10;
-- ===========================================================
-- File: advanced_queries.sql
-- Purpose: Advanced SQL queries for Dental Clinic
--
-- ===========================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 50;

PROMPT [13] PATIENTS WITHOUT UPCOMING APPOINTMENTS (NOT EXISTS)
SELECT p.patient_id AS "Patient ID",
       p.fname || ' ' || p.lname AS "Patient Name"
FROM patient p
WHERE NOT EXISTS (
  SELECT 1
  FROM appointment a
  WHERE a.patient_id = p.patient_id
  AND a.date_time > SYSDATE
);

PROMPT [14] COMBINE SCHEDULED AND COMPLETED APPOINTMENTS (UNION)
SELECT 'Scheduled' AS "Type", appointment_id, date_time
FROM appointment
WHERE status = 'scheduled'
UNION
SELECT 'Completed', appointment_id, date_time
FROM appointment
WHERE status = 'completed'
ORDER BY date_time;

PROMPT [15] TREATMENTS NEVER USED (MINUS)
SELECT treatment_name AS "Unused Treatment"
FROM treatment
MINUS
SELECT DISTINCT t.treatment_name
FROM treatment t
JOIN appt_treatments at ON t.treatment_id = at.treatment_id;

PROMPT [16] AVERAGE BILL PER PATIENT (GROUP BY, HAVING, AVG)
SELECT p.fname || ' ' || p.lname AS "Patient",
       ROUND(AVG(b.total),2) AS "Avg Bill ($)"
FROM billing b
JOIN patient p ON p.patient_id = b.patient_id
GROUP BY p.fname, p.lname
HAVING AVG(b.total) > 100;

PROMPT [17] STAFF WORKLOAD (COUNT, GROUP BY, HAVING)
SELECT s.fname || ' ' || s.lname AS "Staff",
       COUNT(a.appointment_id) AS "Appointments"
FROM dental_staff s
LEFT JOIN appointment a ON s.staff_id = a.staff_id
GROUP BY s.fname, s.lname
HAVING COUNT(a.appointment_id) >= 1;


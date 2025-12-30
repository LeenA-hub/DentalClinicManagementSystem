-- ===========================================================
-- File: dental_queries.sql
-- Purpose: SELECT Queries for Dental Clinic Database
-- Author: Nancy, Elisha, Ameera
-- ===========================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 50;
SET FEEDBACK ON;
SET VERIFY OFF;

BEGIN
    DBMS_OUTPUT.PUT_LINE('===========================================================');
    DBMS_OUTPUT.PUT_LINE(' DENTAL CLINIC DATABASE - QUERY OUTPUT ');
    DBMS_OUTPUT.PUT_LINE('===========================================================');
END;
/

-- ===========================================================
-- 1. Insurance
-- ===========================================================
PROMPT
PROMPT [1] INSURANCE PROVIDERS
PROMPT -----------------------------------------------------------

SELECT insurance_id AS "Insurance ID",
       provider AS "Provider Name",
       policy_num AS "Policy Number"
FROM insurance
ORDER BY provider;

-- ===========================================================
-- 2. Dental Staff
-- ===========================================================
PROMPT
PROMPT [2] DENTAL STAFF (Distinct Specializations)
PROMPT -----------------------------------------------------------

SELECT DISTINCT specialization AS "Specialization"
FROM dental_staff
WHERE specialization IS NOT NULL;

-- ===========================================================
-- 3. Patient
-- ===========================================================
PROMPT
PROMPT [3] PATIENTS AND THEIR INSURANCE PROVIDERS
PROMPT -----------------------------------------------------------

SELECT p.patient_id AS "Patient ID",
       p.fname || ' ' || p.lname AS "Full Name",
       i.provider AS "Insurance Provider"
FROM patient p
LEFT JOIN insurance i ON p.insurance_id = i.insurance_id
ORDER BY p.lname;

-- ===========================================================
-- 4. Appointment
-- ===========================================================
PROMPT
PROMPT [4] APPOINTMENT DETAILS WITH STAFF AND PATIENT NAMES
PROMPT -----------------------------------------------------------

SELECT a.appointment_id AS "Appt ID",
       p.fname || ' ' || p.lname AS "Patient",
       s.fname || ' ' || s.lname AS "Staff",
       a.status AS "Status",
       a.date_time AS "Date/Time"
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN dental_staff s ON a.staff_id = s.staff_id
ORDER BY a.date_time DESC;

-- ===========================================================
-- 5. Treatment
-- ===========================================================
PROMPT
PROMPT [5] TREATMENTS AND COSTS
PROMPT -----------------------------------------------------------

SELECT treatment_name AS "Treatment",
       treatment_cost AS "Cost ($)"
FROM treatment
ORDER BY treatment_cost DESC;

-- ===========================================================
-- 6. Appointment-Treatments
-- ===========================================================
PROMPT
PROMPT [6] TREATMENTS PER APPOINTMENT
PROMPT -----------------------------------------------------------

SELECT a.appointment_id AS "Appointment",
       t.treatment_name AS "Treatment",
       at.notes AS "Notes"
FROM appt_treatments at
JOIN appointment a ON at.appointment_id = a.appointment_id
JOIN treatment t ON at.treatment_id = t.treatment_id;

-- ===========================================================
-- 7. Dental Supplies
-- ===========================================================
PROMPT
PROMPT [7] DENTAL SUPPLIES EXPIRING SOON
PROMPT -----------------------------------------------------------

SELECT item_name AS "Item",
       expiry_date AS "Expiry Date",
       supplier AS "Supplier",
       quantity AS "Stock"
FROM dental_supplies
WHERE expiry_date < ADD_MONTHS(SYSDATE, 6)
ORDER BY expiry_date;

-- ===========================================================
-- 8. OTC Meds
-- ===========================================================
PROMPT
PROMPT [8] OVER-THE-COUNTER MEDICINES
PROMPT -----------------------------------------------------------

SELECT medicine_id AS "ID",
       medicine_name AS "Medicine"
FROM otc_meds;

-- ===========================================================
-- 9. Prescription
-- ===========================================================
PROMPT
PROMPT [9] PRESCRIPTIONS ISSUED
PROMPT -----------------------------------------------------------

SELECT pr.prescription_id AS "Prescription ID",
       p.fname || ' ' || p.lname AS "Patient",
       m.medicine_name AS "Medicine",
       pr.dosage AS "Dosage"
FROM prescription pr
JOIN appointment a ON pr.appt_id = a.appointment_id
JOIN patient p ON a.patient_id = p.patient_id
JOIN otc_meds m ON pr.medicine_id = m.medicine_id;

-- ===========================================================
-- 10. Supply Usage
-- ===========================================================
PROMPT
PROMPT [10] TOTAL SUPPLIES USED PER APPOINTMENT
PROMPT -----------------------------------------------------------

SELECT a.appointment_id AS "Appt ID",
       SUM(su.quantity_used) AS "Total Items Used"
FROM supply_usage su
JOIN appointment a ON su.appointment_id = a.appointment_id
GROUP BY a.appointment_id
ORDER BY a.appointment_id;

-- ===========================================================
-- 11. Billing
-- ===========================================================
PROMPT
PROMPT [11] BILLING SUMMARY BY PATIENT
PROMPT -----------------------------------------------------------

SELECT p.fname || ' ' || p.lname AS "Patient",
       COUNT(b.bill_id) AS "Bills Count",
       SUM(b.total) AS "Total Amount ($)"
FROM billing b
JOIN patient p ON b.patient_id = p.patient_id
GROUP BY p.fname, p.lname
ORDER BY SUM(b.total) DESC;

-- ===========================================================
-- 12. Views
-- ===========================================================
PROMPT
PROMPT [12] VIEW CREATION
PROMPT -----------------------------------------------------------

PROMPT Creating view: v_patient_billing_summary
CREATE OR REPLACE VIEW v_patient_billing_summary AS
SELECT p.fname || ' ' || p.lname AS full_name,
       COUNT(b.bill_id) AS total_bills,
       SUM(b.total) AS total_paid
FROM billing b
JOIN patient p ON b.patient_id = p.patient_id
GROUP BY p.fname, p.lname;

PROMPT Creating view: v_upcoming_appointments
CREATE OR REPLACE VIEW v_upcoming_appointments AS
SELECT a.appointment_id,
       p.fname || ' ' || p.lname AS patient,
       s.fname || ' ' || s.lname AS staff,
       a.date_time AS appointment_time,
       a.status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN dental_staff s ON a.staff_id = s.staff_id
WHERE a.date_time > SYSDATE;

PROMPT Creating view: v_supply_usage_summary
CREATE OR REPLACE VIEW v_supply_usage_summary AS
SELECT ds.item_name,
       SUM(su.quantity_used) AS total_used
FROM supply_usage su
JOIN dental_supplies ds ON su.item_id = ds.item_id
GROUP BY ds.item_name;

PROMPT
PROMPT ===========================================================
PROMPT END OF FILE - ALL QUERIES EXECUTED
PROMPT ===========================================================

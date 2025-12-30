-- ===========================================================
-- File: insert_data.sql
-- Purpose: Populate Dental Clinic database with sample data
-- Author: Ameera Almuti
-- ===========================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 100;
PROMPT Populating Dental Clinic Tables...
PROMPT ===========================================================

-- ===== Insurance =====
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (1, 'SunLife', 'POL1001');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (2, 'Manulife', 'POL1002');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (3, 'BlueCross', 'POL1003');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (4, 'GreenShield', 'POL1004');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (5, 'CanadaLife', 'POL1005');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (6, 'Desjardins', 'POL1006');
INSERT INTO insurance (insurance_id, provider, policy_num) VALUES (7, 'RBC Insurance', 'POL1007');

-- ===== Patients =====
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (1, 'Alice', 'Wong', '416-111-2222', 1);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (2, 'Brian', 'Lee', '416-333-4444', 2);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (3, 'Cathy', 'Nguyen', '416-555-6666', 3);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (4, 'David', 'Smith', '416-777-8888', 4);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (5, 'Ella', 'Martinez', '437-123-4567', 5);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (6, 'Farah', 'Ali', '647-999-8888', 6);
INSERT INTO patient (patient_id, fname, lname, phone, insurance_id)
VALUES (7, 'George', 'Chen', '647-777-1234', 7);

-- ===== Dental Staff =====
INSERT INTO dental_staff (staff_id, fname, lname, specialization)
VALUES (1, 'Dr. Jane', 'Doe', 'Dentist');
INSERT INTO dental_staff (staff_id, fname, lname, specialization)
VALUES (2, 'Dr. Mark', 'Patel', 'Orthodontist');
INSERT INTO dental_staff (staff_id, fname, lname, specialization)
VALUES (3, 'Sara', 'Chan', 'Hygienist');

-- ===== Appointment =====
INSERT INTO appointment (appointment_id, patient_id, staff_id, date_time, status)
VALUES (1, 1, 1, TO_DATE('2025-09-01 09:00', 'YYYY-MM-DD HH24:MI'), 'completed');
INSERT INTO appointment (appointment_id, patient_id, staff_id, date_time, status)
VALUES (2, 2, 2, TO_DATE('2025-11-10 14:_

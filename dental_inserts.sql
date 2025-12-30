-- =========================
-- INSERTS for dental_ddl.sql
-- =========================

-- -------------------------
-- supply_product + supply_inventory
-- -------------------------
INSERT INTO supply_product (item_id, item_name, supplier)
VALUES (2, 'Surgical Masks', 'DentalGear');

INSERT INTO supply_inventory (item_id, expiry_date, quantity)
VALUES (2, TO_DATE('2026-06-30','YYYY-MM-DD'), 1000);

INSERT INTO supply_product (item_id, item_name, supplier)
VALUES (3, 'Dental Floss', 'OralCare');

INSERT INTO supply_inventory (item_id, expiry_date, quantity)
VALUES (3, TO_DATE('2027-01-15','YYYY-MM-DD'), 300);

INSERT INTO supply_product (item_id, item_name, supplier)
VALUES (4, 'Toothbrush', 'BrushTech');

INSERT INTO supply_inventory (item_id, expiry_date, quantity)
VALUES (4, TO_DATE('2027-05-10','YYYY-MM-DD'), 1500);

-- expired / zero quantity example (edge case)
INSERT INTO supply_inventory (item_id, expiry_date, quantity)
VALUES (2, TO_DATE('2020-12-31','YYYY-MM-DD'), 0);

-- -------------------------
-- insurance
-- -------------------------
INSERT INTO insurance (insurance_id, provider, policy_num, coverage_detail)
VALUES (2, 'HealthPlus', 'POL67890', 'Premium coverage - includes root canal coverage.');

INSERT INTO insurance (insurance_id, provider, policy_num, coverage_detail)
VALUES (3, 'CareSecure', 'POL11223', 'Standard coverage - basic procedures.');

INSERT INTO insurance (insurance_id, provider, policy_num, coverage_detail)
VALUES (4, 'MediSafe', 'POL44556', 'Basic coverage - limited to preventive care.');

-- -------------------------
-- dental_staff
-- -------------------------
INSERT INTO dental_staff (staff_id, fname, lname, specialization, work_schedule, email, phone_num)
VALUES (2, 'Liam', 'Smith', 'Endodontist', 'Mon-Fri 09:00-17:00', 'liam.smith@dentist.com', '416-555-1002');

INSERT INTO dental_staff (staff_id, fname, lname, specialization, work_schedule, email, phone_num)
VALUES (3, 'Sophie', 'Nguyen', 'Hygienist', 'Tue-Thu 08:00-14:00', 'sophie.nguyen@dentist.com', '416-555-1003');

INSERT INTO dental_staff (staff_id, fname, lname, specialization, work_schedule, email, phone_num)
VALUES (4, 'Carlos', 'Rodriguez', 'General Dentist', 'Mon-Wed-Fri 10:00-18:00', 'carlos.rodriguez@dentist.com', '416-555-1004');

-- -------------------------
-- patient
-- -------------------------
INSERT INTO patient (patient_id, fname, lname, contact_num, insurance_id, dob, gender, address, medical_history)
VALUES (2, 'Alice', 'Johnson', '416-555-0200', 2, TO_DATE('1985-08-15','YYYY-MM-DD'), 'Female', '12 King St, Toronto, ON', 'No known allergies.');

INSERT INTO patient (patient_id, fname, lname, contact_num, insurance_id, dob, gender, address, medical_history)
VALUES (3, 'Ethan', 'Williams', '416-555-0300', 3, TO_DATE('2000-12-01','YYYY-MM-DD'), 'Male', '45 Queen St, Toronto, ON', 'Asthma - uses inhaler.');

INSERT INTO patient (patient_id, fname, lname, contact_num, insurance_id, dob, gender, address, medical_history)
VALUES (4, 'Emily', 'Davis', '416-555-0400', 4, TO_DATE('1995-04-10','YYYY-MM-DD'), 'Female', '78 Bathurst St, Toronto, ON', 'Penicillin allergy.');

-- Edge-case: patient without insurance
INSERT INTO patient (patient_id, fname, lname, contact_num, insurance_id, dob, gender, address, medical_history)
VALUES (5, 'NoInsurance', 'Example', '416-555-0500', NULL, TO_DATE('1990-01-01','YYYY-MM-DD'), 'Non-binary', '100 Example Ave, Toronto, ON', 'No history recorded.');

-- -------------------------
-- appointment
-- -------------------------
INSERT INTO appointment (appointment_id, patient_id, staff_id, description, status, date_time)
VALUES (2, 2, 2, 'Follow-up checkup', 'scheduled', TO_TIMESTAMP('2025-09-25 10:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO appointment (appointment_id, patient_id, staff_id, description, status, date_time)
VALUES (3, 3, 3, 'Routine cleaning', 'completed', TO_TIMESTAMP('2025-09-20 09:00:00','YYYY-MM-DD HH24:MI:SS'));

INSERT INTO appointment (appointment_id, patient_id, staff_id, description, status, date_time)
VALUES (4, 4, 4, 'Emergency consult', 'scheduled', TO_TIMESTAMP('2025-09-26 16:00:00','YYYY-MM-DD HH24:MI:SS'));

-- overlapping appointment example for same staff (edge demonstration)
INSERT INTO appointment (appointment_id, patient_id, staff_id, description, status, date_time)
VALUES (5, 5, 2, 'Check overlapping time slot', 'scheduled', TO_TIMESTAMP('2025-09-25 10:30:00','YYYY-MM-DD HH24:MI:SS'));

-- -------------------------
-- treatment
-- -------------------------
INSERT INTO treatment (treatment_id, treatment_name, treatment_description, treatment_cost)
VALUES (2, 'Root Canal', 'Endodontic therapy for pulp infection', 350.00);

INSERT INTO treatment (treatment_id, treatment_name, treatment_description, treatment_cost)
VALUES (3, 'Cavity Filling', 'Composite filling for small cavity', 125.00);

INSERT INTO treatment (treatment_id, treatment_name, treatment_description, treatment_cost)
VALUES (4, 'Tooth Extraction', 'Simple extraction procedure', 200.00);

-- -------------------------
-- appt_treatments (many-to-many)
-- -------------------------
INSERT INTO appt_treatments (appointment_id, treatment_id, notes)
VALUES (2, 2, 'Root canal treatment for lower molar.');

INSERT INTO appt_treatments (appointment_id, treatment_id, notes)
VALUES (3, 3, 'Filling for upper premolar.');

INSERT INTO appt_treatments (appointment_id, treatment_id, notes)
VALUES (4, 4, 'Extraction due to severe decay.');

-- -------------------------
-- otc_meds
-- -------------------------
INSERT INTO otc_meds (medicine_id, medicine_name)
VALUES (2, 'Ibuprofen');

INSERT INTO otc_meds (medicine_id, medicine_name)
VALUES (3, 'Aspirin');

INSERT INTO otc_meds (medicine_id, medicine_name)
VALUES (4, 'Antiseptic Mouthwash');

-- -------------------------
-- prescription
-- -------------------------
INSERT INTO prescription (prescription_id, appt_id, record_id, medicine_id, prescribed_by, dosage, frequency, duration, use_notes)
VALUES (2, 2, 'REC002', 2, 2, '200mg', 'q6h', '5 days', 'Take with food.');

INSERT INTO prescription (prescription_id, appt_id, record_id, medicine_id, prescribed_by, dosage, frequency, duration, use_notes)
VALUES (3, 3, 'REC003', 3, 3, '500mg', 'q8h', '7 days', 'Avoid alcohol.');

INSERT INTO prescription (prescription_id, appt_id, record_id, medicine_id, prescribed_by, dosage, frequency, duration, use_notes)
VALUES (4, 4, 'REC004', 4, 4, '10ml', 'twice daily', '7 days', 'Use as mouthwash.');

-- -------------------------
-- supply_usage
-- -------------------------
INSERT INTO supply_usage (usage_id, item_id, appointment_id, quantity_used, notes)
VALUES (2, 2, 2, 50, 'Used during root canal');

INSERT INTO supply_usage (usage_id, item_id, appointment_id, quantity_used, notes)
VALUES (3, 3, 3, 20, 'Dental floss provided');

INSERT INTO supply_usage (usage_id, item_id, appointment_id, quantity_used, notes)
VALUES (4, 4, 4, 3, 'Toothbrush given after cleaning');

-- -------------------------
-- billing
-- -------------------------
INSERT INTO billing (bill_id, patient_id, appointment_id, total, pay_method, pay_date)
VALUES (2, 2, 2, 350.00, 'card', SYSDATE);

INSERT INTO billing (bill_id, patient_id, appointment_id, total, pay_method, pay_date)
VALUES (3, 3, 3, 125.00, 'cash', SYSDATE);

INSERT INTO billing (bill_id, patient_id, appointment_id, total, pay_method, pay_date)
VALUES (4, 4, 4, 200.00, 'insurance', SYSDATE);

-- Unpaid bill / unpaid example (pay_date NULL)
INSERT INTO billing (bill_id, patient_id, appointment_id, total, pay_method, pay_date)
VALUES (5, 5, NULL, 150.00, 'card', NULL);

-- -------------------------
-- Finalize
-- -------------------------
COMMIT;

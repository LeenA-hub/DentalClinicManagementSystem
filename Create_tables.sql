-- ===========================================================
-- File: create_tables.sql
-- Purpose: Define Dental Clinic database schema for the script
-- ===========================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 100;
PROMPT Creating Dental Clinic Tables...
PROMPT ===========================================================

-- Drop tables if they already exist (for reruns)
BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
PROMPT All existing tables dropped.
PROMPT -----------------------------------------------------------

-- ===== INSURANCE =====
CREATE TABLE insurance (
    insurance_id     NUMBER PRIMARY KEY,
    provider         VARCHAR2(50),
    policy_num       VARCHAR2(30)
);

-- ===== PATIENT =====
CREATE TABLE patient (
    patient_id       NUMBER PRIMARY KEY,
    fname            VARCHAR2(30) NOT NULL,
    lname            VARCHAR2(30) NOT NULL,
    phone            VARCHAR2(20),
    insurance_id     NUMBER,
    CONSTRAINT fk_patient_ins FOREIGN KEY (insurance_id)
        REFERENCES insurance(insurance_id)
);

-- ===== DENTAL STAFF =====
CREATE TABLE dental_staff (
    staff_id         NUMBER PRIMARY KEY,
    fname            VARCHAR2(30) NOT NULL,
    lname            VARCHAR2(30) NOT NULL,
    specialization   VARCHAR2(40)
);

-- ===== APPOINTMENT =====
CREATE TABLE appointment (
    appointment_id   NUMBER PRIMARY KEY,
    patient_id       NUMBER NOT NULL,
    staff_id         NUMBER NOT NULL,
    date_time        DATE,
    status           VARCHAR2(15),
    CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id),
    CONSTRAINT fk_appt_staff FOREIGN KEY (staff_id)
        REFERENCES dental_staff(staff_id)
);

-- ===== TREATMENT =====
CREATE TABLE treatment (
    treatment_id     NUMBER PRIMARY KEY,
    treatment_name   VARCHAR2(50) NOT NULL,
    treatment_cost   NUMBER(10,2)
);

-- ===== APPOINTMENT–TREATMENTS =====
CREATE TABLE appt_treatments (
    appointment_id   NUMBER,
    treatment_id     NUMBER,
    notes            VARCHAR2(100),
    CONSTRAINT pk_appt_treatments PRIMARY KEY (appointment_id, treatment_id),
    CONSTRAINT fk_at_appt FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),
    CONSTRAINT fk_at_treat FOREIGN KEY (treatment_id)
        REFERENCES treatment(treatment_id)
);

-- ===== BILLING =====
CREATE TABLE billing (
    bill_id          NUMBER PRIMARY KEY,
    patient_id       NUMBER NOT NULL,
    appointment_id   NUMBER NOT NULL,
    total            NUMBER(10,2),
    CONSTRAINT fk_bill_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id),
    CONSTRAINT fk_bill_appt FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
);

-- ===== PAYMENT =====
CREATE TABLE payment (
    payment_id       NUMBER PRIMARY KEY,
    patient_id       NUMBER NOT NULL,
    amount           NUMBER(10,2),
    CONSTRAINT fk_payment_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
);

-- ===== DENTAL SUPPLIES =====
CREATE TABLE dental_supplies (
    item_id          NUMBER PRIMARY KEY,
    item_name        VARCHAR2(50),
    expiry_date      DATE,
    supplier         VARCHAR2(50),
    quantity         NUMBER
);

-- ===== SUPPLY USAGE =====
CREATE TABLE supply_usage (
    usage_id         NUMBER PRIMARY KEY,
    appointment_id   NUMBER,
    item_id          NUMBER,
    quantity_used    NUMBER,
    CONSTRAINT fk_usage_appt FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),
    CONSTRAINT fk_usage_item FOREIGN KEY (item_id)
        REFERENCES dental_supplies(item_id)
);

-- ===== OTC MEDS =====
CREATE TABLE otc_meds (
    medicine_id      NUMBER PRIMARY KEY,
    medicine_name    VARCHAR2(50)
);

-- ===== PRESCRIPTION =====
CREATE TABLE prescription (
    prescription_id  NUMBER PRIMARY KEY,
    appt_id          NUMBER,
    medicine_id      NUMBER,
    dosage           VARCHAR2(50),
    CONSTRAINT fk_pres_appt FOREIGN KEY (appt_id)
        REFERENCES appointment(appointment_id),
    CONSTRAINT fk_pres_med FOREIGN KEY (medicine_id)
        REFERENCES otc_meds(medicine_id)
);

PROMPT ===========================================================
PROMPT All tables created successfully.

-- v_doctor_revenue: show each doctor and their total revenue (0 for no revenue)
CREATE OR REPLACE VIEW v_doctor_revenue AS
SELECT
  d.staff_id,                                          -- doctor's unique id (useful for joins)
  d.fname || ' ' || d.lname AS doctor_name,           -- readable doctor name
  NVL(SUM(b.total), 0) AS total_revenue                -- sum of billing totals; NVL -> 0 if no bills
FROM dental_staff d
LEFT JOIN appointment a ON a.staff_id = d.staff_id    -- LEFT JOIN: include doctors with NO appointments
LEFT JOIN billing b ON b.appointment_id = a.appointment_id  -- LEFT JOIN: include appointments with no billing
GROUP BY
  d.staff_id, d.fname, d.lname;                       -- group by unique id + name to avoid name collision

-- v_patient_balance: outstanding balance per patient (always numeric; 0 if nothing owed)
CREATE OR REPLACE VIEW v_patient_balance AS
SELECT
  p.patient_id,                                       -- patient id for cross-checks
  p.fname || ' ' || p.lname AS patient_name,         -- readable patient name
  NVL(SUM(b.total),0) - NVL(SUM(pay.amount),0) AS outstanding_balance
                                                      -- ensure both sums are NVL'd so result is numeric (not NULL)
FROM patient p
LEFT JOIN billing b ON b.patient_id = p.patient_id   -- LEFT JOIN: include patients without any billing
LEFT JOIN payment pay ON pay.patient_id = p.patient_id
                                                      -- LEFT JOIN: include patients without payments
GROUP BY
  p.patient_id, p.fname, p.lname;                     -- group by id + name to uniquely identify rows

-- v_service_stats: stats per treatment (times performed, average appointment bill for appointments that included the treatment)
-- Avoids double-counting billing totals when appointments have multiple treatments by computing appointment-level totals first.
CREATE OR REPLACE VIEW v_service_stats AS
SELECT
  t.treatment_id,                                     -- treatment id for clarity and joins
  t.treatment_name,                                   -- readable treatment name
  COUNT(at.appointment_id) AS times_performed,        -- how many times this treatment appears in appt_treatments
  ROUND(AVG(ab.appointment_total), 2) AS avg_bill     -- average appointment-level total for appointments that included this treatment
FROM treatment t
LEFT JOIN appt_treatments at ON t.treatment_id = at.treatment_id
                                                      -- LEFT JOIN so treatments never performed still appear (count = 0)
LEFT JOIN (
    SELECT appointment_id, NVL(SUM(total),0) AS appointment_total
    FROM billing
    GROUP BY appointment_id
) ab ON ab.appointment_id = at.appointment_id
                                                      -- subquery gives a single appointment-level total (prevents duplication)
GROUP BY
  t.treatment_id, t.treatment_name;                   -- group by id + name for uniqueness

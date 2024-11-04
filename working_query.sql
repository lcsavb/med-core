SELECT id, patient_id, schedule_id, medical_records_id, appointment_date, clinic_id, healthcare_professional_id
FROM appointments
WHERE clinic_id = 1
  AND healthcare_professional_id = 4
  AND DATE(appointment_date) = '2024-10-31'
ORDER BY appointment_date;

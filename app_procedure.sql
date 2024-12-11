DELIMITER $$

CREATE PROCEDURE CreateAppointment(
    IN p_clinic_id INT,
    IN p_doctor_id INT,
    IN p_patient_id INT,
    IN p_appointment_date DATETIME,
    IN p_confirmed TINYINT
)
BEGIN
    DECLARE v_schedule_id INT;
    DECLARE v_care_link_id INT;

    -- Step 1: Get the schedule_id for the given doctor and clinic
    SELECT id INTO v_schedule_id
    FROM schedules
    WHERE doctor_id = p_doctor_id AND clinic_id = p_clinic_id
    LIMIT 1;

    -- If no schedule exists, raise an error
    IF v_schedule_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No schedule found for the given doctor and clinic.';
    END IF;

    -- Step 2: Get the care_link_id for the given doctor, clinic, and patient
    SELECT id INTO v_care_link_id
    FROM care_link
    WHERE clinic_id = p_clinic_id AND doctor_id = p_doctor_id AND patient_id = p_patient_id
    LIMIT 1;

    -- If no care link exists, raise an error
    IF v_care_link_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No care link found for the given doctor, clinic, and patient.';
    END IF;

    -- Step 3: Insert the new appointment
    INSERT INTO appointments (schedule_id, appointment_date, confirmed, care_link_id)
    VALUES (v_schedule_id, p_appointment_date, p_confirmed, v_care_link_id);

END$$

DELIMITER ;
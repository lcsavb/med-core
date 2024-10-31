INSERT INTO clinics (
        id,
        name,
        address,
        address_number,
        address_complement,
        zip,
        city,
        state,
        country,
        phone,
        email,
        website,
        clinic_type,
        admin_user_id,
        created_at
    )
VALUES (
        -- Generate random values for each column
        1, -- id
        'Random Name', -- name
        'Random Address', -- address
        '1', -- address_number
        'Random Complement', -- address_complement
        '2', -- zip
        'Random City', -- city
        'Random State', -- state
        'Random Country', -- country
        'Random Phone', -- phone
        'Random Email', -- email
        'Random Website', -- website
        'Random Clinic Type', -- clinic_type
        1, -- admin_user_id
        NOW() -- created_at
);


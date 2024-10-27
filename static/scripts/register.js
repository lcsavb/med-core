$('#registerForm').on('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way

    const username = $('#username').val();
    const password = $('#password').val();
    const email = $('#email').val();
    const name = $('#name').val();
    const phone = $('#phone').val();
    const is_doctor = $('#is_doctor').val();

    try {
        // Send registration request to the server
        const response = await fetch('/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                username: username,
                password: password,
                email: email,
                name: name,
                phone: phone,
                is_doctor: is_doctor,
            }),
        });

        // Parse JSON response
        const data = await response.json();

        if (response.ok) {
            // Hide the registration form and show success message
            $('#registerContainer').hide();
            $('#registerSuccessMessage').show();
        } else {
            // Show an error message if registration fails
            alert(data.message || 'Registration failed, please try again.');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('An error occurred, please try again.');
    }
});


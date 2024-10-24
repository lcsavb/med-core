document.getElementById('registerForm').addEventListener('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const email = document.getElementById('email').value;
    const name = document.getElementById('name').value;
    const phone = document.getElementById('phone').value;
    const is_doctor = document.getElementById('is_doctor').value;

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

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        
        const data = await response.json();

        if (response.ok) {
            // Hide the registration form and show success message
            document.getElementById('registerContainer').style.display = 'none';
            document.getElementById('registerSuccessMessage').style.display = 'block';
        } else {
            // Show an error message if registration fails
            alert(data.message || 'Registration failed, please try again.');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('An error occurred, please try again.');
    }
});
String? validateInput(String? value, String type, {String? password}) {
  if (value == null || value.isEmpty) {
    return type == 'password'
        ? 'Please enter your password'
        : type == 'email'
            ? 'Please enter your email'
            : 'Please enter your name';
  }

  // Email Validation
  if (type == 'email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Enter a valid email';
  }

  // Password Validation
  if (type == 'password') {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
  }

  // Confirm Password Validation
  if (type == 'confirm_password' && password != null) {
    if (value != password) {
      return 'Passwords do not match';
    }
  }

  return null;
}

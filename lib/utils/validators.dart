class Validators {
  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email address";
    }

    return null;
  }

  // Strong Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain an uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain a lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain a number";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?\":{}|<>]').hasMatch(value)) {
      return "Password must contain a special character";
    }

    return null;
  }

  // Confirm Password
  static String? validateConfirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }
}
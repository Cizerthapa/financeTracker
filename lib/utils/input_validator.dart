class InputValidators {
  InputValidators._();

  static RegExp emailRegEx = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp passwordReg = RegExp(
    r'^(?=.[a-z])(?=.[A-Z])(?=.\d)(?=.[#@$!%?&])[A-Za-z\d#@$!%?&]{8,}$',
  );
  static final RegExp numberReg = RegExp(r'^(?!([0-9])\1{9})[0-9]{10}$');

  static String? userNameValidator(String? value) {
    if (value == null) {
      return 'Username/mobile/email is required';
    } else if (value.isEmpty) {
      return 'Username/mobile/email is required';
    } else {
      return null;
    }
  }

  static String? fieldRequireValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required*';
    } else {
      return null;
    }
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    } else if (value.trim().length < 5) {
      return 'Username must be at least 5 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? userNameValidatorForSignUp(String? value) {
    if (value == null) {
      return 'Username is required';
    } else if (value.isEmpty) {
      return 'Username is required';
    } else {
      return null;
    }
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    return (email.isNotEmpty && !emailRegEx.hasMatch(email))
        ? 'Invalid Email'
        : null;
  }

  static String? validatePassword(
    String? password, {
    bool isThereConfirmPassword = false,
    String? oldPassword = '',
    int minCharacter = 8,
    bool isRegEx = false,
  }) {
    if (password == null || password.isEmpty) {
      return 'This field is required.';
    }

    if (password.length < 8) {
      return 'Password should have minimum length of 8.';
    }

    if (oldPassword != null &&
        oldPassword.trim() == password.trim() &&
        isThereConfirmPassword) {
      return 'Current password & new password must be different.';
    }

    return null;
  }

  static String? validateConfirmPassword({
    String? password,
    String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'This field is required.';
    }
    if (password != confirmPassword) {
      return 'Password and confirm password does not match.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? number) {
    return number == null || number.isEmpty
        ? 'Mobile number is required'
        : !number.startsWith('9')
        ? 'Invalid mobile number'
        : numberReg.hasMatch(number)
        ? null
        : number.length == 10
        ? null
        : 'Invalid mobile number';
  }

  static String? validateMessage(String? value) {
    return value == null || value.isEmpty ? 'Message is required' : null;
  }
}

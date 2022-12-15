// create class Validation with static method validate phone and password
class Validation {
  static isPhoneValid(String phone) {
    // Regex for phone number validation
    final RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phone);
  }

  static isPasswordValid(String password) {
    // Regex for password > 6 characters and < 20 characters and contain at least 1 number and no space character allowed in password string
    final RegExp regex = RegExp(r'^(?=.*[0-9])[a-zA-Z0-9!@#\$%\^&\*]{6,20}$');
    return regex.hasMatch(password);
  }

  static isDisplayNameValid(String displayName) {
    // At least two words
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]{2,}$');
    return regex.hasMatch(displayName);
  }
}

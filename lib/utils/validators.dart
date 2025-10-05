class AppValidators {
  /// Validate if string is a valid positive number
  static bool isValidPositiveNumber(String value) {
    if (value.isEmpty) return false;

    final number = double.tryParse(value);
    if (number == null) return false;

    return number > 0;
  }

  /// Validate quantity input
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a quantity';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return 'Quantity must be greater than 0';
    }

    return null;
  }

  /// Validate coin selection
  static String? validateCoinSelection(String? coinId) {
    if (coinId == null || coinId.isEmpty) {
      return 'Please select a cryptocurrency';
    }
    return null;
  }

  static String sanitizeNumericInput(String input) {
    // Remove all non-numeric characters except decimal point
    return input.replaceAll(RegExp(r'[^\d.]'), '');
  }
}

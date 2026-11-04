/// Utility for formatting numerals and currency according to Bengali / English locale.
class NumberFormatter {
  NumberFormatter._();

  static const Map<String, String> _bengaliDigits = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  /// Converts ASCII digits to Bengali digits.
  static String toBengaliDigits(dynamic value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      buffer.write(_bengaliDigits[char] ?? char);
    }
    return buffer.toString();
  }

  /// Converts Bengali digits to ASCII digits (for inputs like phone and OTP).
  static String toAsciiDigits(String input) {
    const reverseMap = {
      '০': '0',
      '১': '1',
      '২': '2',
      '৩': '3',
      '৪': '4',
      '৫': '5',
      '৬': '6',
      '৭': '7',
      '৮': '8',
      '৯': '9',
    };
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(reverseMap[char] ?? char);
    }
    return buffer.toString();
  }

  /// Formats currency with ৳ symbol and localized digits.
  static String formatCurrency(num amount, {required String languageCode}) {
    final formatted = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(1);
    if (languageCode == 'bn') {
      return '৳ ${toBengaliDigits(formatted)}';
    }
    return '৳ $formatted';
  }

  /// Formats numbers (e.g. countdown seconds, scores, counts) based on language.
  static String formatNumber(dynamic number, {required String languageCode}) {
    if (languageCode == 'bn') {
      return toBengaliDigits(number);
    }
    return number.toString();
  }
}


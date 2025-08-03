class DateHelper {
  /// Returns a formatted string for current month like "2025-08"
  static String getCurrentMonthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// Checks if two month keys are the same (e.g., "2025-08")
  static bool isSameMonth(String a, String b) {
    return a == b;
  }
}

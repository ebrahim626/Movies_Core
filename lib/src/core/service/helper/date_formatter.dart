import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _display = DateFormat('dd MMM yyyy');

  /// "2005-09-12" -> "12 Sep 2005"
  /// Returns [fallback] if the value is null, empty or not a valid date.
  static String format(String? date, {String fallback = 'N/A'}) {
    if (date == null || date.trim().isEmpty) return fallback;

    final parsed = DateTime.tryParse(date);
    if (parsed == null) return fallback;

    return _display.format(parsed);
  }
}
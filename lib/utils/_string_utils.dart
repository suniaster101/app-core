part of 'utils.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class Format {
  static final _currency =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format;

  static String currency(dynamic value) {
    if (value is double?) {
      if ((value ?? 0).abs() < 1) {
        return value.toString();
      }
    }
    return _currency(value);
  }
}

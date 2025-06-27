part of 'utils.dart';

class FormatDate {
  static DateFormat id(String format) {
    return DateFormat(format, "id_ID");
  }

  static DateFormat en(String format) {
    return DateFormat(format, "en_US");
  }
}

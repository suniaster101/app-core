part of 'utils.dart';

class Log {
  static final _logger = Logger();

  static void i(dynamic data, {String title = ''}) {
    _logger.i(title.isEmpty ? data : {'title': title, 'body': data});
  }

  static void w(dynamic data, {String title = ''}) {
    _logger.w(title.isEmpty ? data : {'title': title, 'body': data});
  }

  static void e(dynamic data, {String title = ''}) {
    _logger.e(title.isEmpty ? data : {'title': title, 'body': data});
  }
}

part of 'utils.dart';

class Screen {
  static late MediaQueryData _mediaQueryData;
  static late BuildContext _context;

  static void init(BuildContext context) {
    _context = context;
    _mediaQueryData = MediaQuery.of(_context);
  }

  static MediaQueryData get data => _mediaQueryData;
  static double get paddingTop => _mediaQueryData.padding.top;
  static double get paddingBottom => _mediaQueryData.padding.bottom;
  static double get paddingLeft => _mediaQueryData.padding.left;
  static double get paddingRight => _mediaQueryData.padding.right;
  static double get width => _mediaQueryData.size.width;
  static double get height => _mediaQueryData.size.height;
  static bool get isMobile => MediaQuery.of(_context).size.shortestSide <= 450;
  static bool get isTablet =>
      MediaQuery.of(_context).size.shortestSide <= 800 &&
      MediaQuery.of(_context).size.shortestSide > 450;
  static bool get isSmallTablet =>
      (MediaQuery.of(_context).size.shortestSide >= 600);
}

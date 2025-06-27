// 🐦 Flutter imports:
// ignore_for_file: deprecated_member_use

import 'package:appcore/services/_session_service.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export '_text_styles.dart';

class Themes {
  // Base Colors
  static Color primary = const Color(0xFF4162FF);
  static Color primary2 = const Color(0xFFB1E2FF);
  static Color blue1 = const Color(0xFFF8F6FF);
  static Color blue2 = const Color(0xFFE7F6FF);
  static Color blue3 = const Color(0xFFE7F6FF);
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color red = const Color(0xFFFF7272);
  static Color red50 = const Color(0xFFFFECED);
  static Color cream = const Color(0xFFCFB590);
  static Color yellow = const Color(0xFFEEA721);
  static Color brown = const Color(0xFFE6931B);
  static Color grey = const Color(0xFF6A9FC5);

  static Color background = const Color(0xFFF7F9FA);
  // neutral Colors
  static Color neutral1 = const Color(0xFFF8F8F8);
  static Color neutral2 = const Color(0xFFEAEAEA);
  static Color neutral3 = const Color(0xFFBEBBBB);
  static Color neutral4 = const Color(0xFFA5A4C4);
  static Color neutral5 = const Color(0xFF4F4D74);
  static Color neutral6 = const Color(0xFF313030);
  static Color neutral7 = const Color(0xFF0A0A0A);

  static LinearGradient harmoniGradient = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFF057EFF), Color(0xFF4EBCFF)],
  );

  static init({bool isMobile = false}) async {
    // // primary1 = const Color(0xffe6f1fd);
    // final themsBox = await Hive.openBox('Themes');
    // // final curr = themsBox.get('currentVal', defaultValue: 0xffffffff) as int;
    // // neutral1 = Color(curr);
    // themsBox.listenable().addListener(() {
    //   // final curr = themsBox.get('currentVal', defaultValue: 0xffffffff) as int;
    //   // neutral1 = Color(curr);
    // });
    shadow1 = _shadow1;
    shadow3 = _shadow3;
    shadow6 = _shadow6;
    softShadow = _softShadow;
    Log.w("isMobile $isMobile");
    _updateUIMode(forceUpdate: false, isMobile: isMobile);
  }

  static updateColors({required Map<String, String> colors}) {
    primary = Color(int.tryParse(colors['primary'] ?? '') ?? 0xFF4162FF);
    primary2 = Color(int.tryParse(colors['primary2'] ?? '') ?? primary2.value);
    blue2 = Color(int.tryParse(colors['blue2'] ?? '') ?? blue2.value);
    blue3 = Color(int.tryParse(colors['blue3'] ?? '') ?? blue3.value);
    white = Color(int.tryParse(colors['white'] ?? '') ?? white.value);
    black = Color(int.tryParse(colors['black'] ?? '') ?? black.value);
    red = Color(int.tryParse(colors['red'] ?? '') ?? red.value);
    cream = Color(int.tryParse(colors['cream'] ?? '') ?? cream.value);
    yellow = Color(int.tryParse(colors['yellow'] ?? '') ?? yellow.value);
    brown = Color(int.tryParse(colors['brown'] ?? '') ?? brown.value);
    neutral1 = Color(int.tryParse(colors['neutral1'] ?? '') ?? neutral1.value);
    neutral2 = Color(int.tryParse(colors['neutral2'] ?? '') ?? neutral2.value);
    neutral3 = Color(int.tryParse(colors['neutral3'] ?? '') ?? neutral3.value);
    neutral4 = Color(int.tryParse(colors['neutral4'] ?? '') ?? neutral4.value);
    neutral5 = Color(int.tryParse(colors['neutral5'] ?? '') ?? neutral5.value);
    neutral6 = Color(int.tryParse(colors['neutral6'] ?? '') ?? neutral6.value);
    neutral7 = Color(int.tryParse(colors['neutral7'] ?? '') ?? neutral7.value);

    App.forceUpdate();
  }

  static toggleUIMode(BuildContext context) {
    Session.i.toggleUIMode().then((value) {
      if (context.mounted) {
        _updateUIMode(isMobile: Screen.isMobile);
      }
    });
  }

  static Color reduceSaturation(Color color, double factor) {
    assert(factor >= 0 && factor <= 1, 'Factor should be between 0 and 1');
    final hsl = HSLColor.fromColor(color);
    final newHsl = hsl.withSaturation(hsl.saturation * factor);
    return newHsl.toColor();
  }

  static get light => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      );
  static get dark => SystemUiOverlayStyle(
        statusBarColor: Colors.white.withAlpha((.01 * 255).toInt()),
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: true,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      );

  static _updateUIMode({bool forceUpdate = true, bool isMobile = false}) {
    SystemChrome.setEnabledSystemUIMode(
        isMobile ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ]);
    if (Session.i.isDarkMode) {
      // Light Overlay Style
      SystemChrome.setSystemUIOverlayStyle(light);

      // primary = const Color(0xFF4162FF);
      // primary2 = const Color(0xFF4A90E2);
      // blue1 = const Color(0xFF1A1A2E);
      // blue2 = const Color(0xFF162447);
      // blue3 = const Color(0xFF162447);
      // white = const Color(0xFF1E1E1E);
      // black = const Color(0xFFFFFFFF);
      // red = const Color(0xFFFF4C4C);
      // red50 = const Color(0xFF4C0000);
      // cream = const Color(0xFF8B6B48);
      // yellow = const Color(0xFFD48806);
      // brown = const Color(0xFF8C5723);
      // grey = const Color(0xFF7A8C9E);
      // background = const Color(0xFF121212);
      // neutral1 = const Color(0xFF1E1E1E);
      // neutral2 = const Color(0xFF2C2C2C);
      // neutral3 = const Color(0xFF3C3C3C);
      // neutral4 = const Color(0xFF4A4A4A);
      // neutral5 = const Color(0xFF5A5A5A);
      // neutral6 = const Color(0xFF6A6A6A);
      // neutral7 = const Color(0xFF7A7A7A);
      // harmoniGradient = const LinearGradient(
      //     begin: Alignment.bottomCenter,
      //     end: Alignment.topCenter,
      //     // colors: [Color(0xFF0D47A1), Color(0xFF1976D2)], // Darker shades of blue
      //     colors: [Color(0xff2A1749), Color(0xFF632D8D), Color(0xFF8146B0)]);
      double saturationFactor = 0.7;

      primary = const Color(0xFF0BA9FF);
      // primary = reduceSaturation(const Color(0xFF4162FF), saturationFactor);
      primary2 = reduceSaturation(const Color(0xFF4A90E2), saturationFactor);
      blue1 = reduceSaturation(const Color(0xFF1A1A2E), saturationFactor);
      blue2 = reduceSaturation(const Color(0xFF162447), saturationFactor);
      blue3 = reduceSaturation(const Color(0xFF162447), saturationFactor);
      // white = const Color(0xFF1E1E1E); // Dark card color
      white = const Color(0xFF1E2537); // Dark card color
      black = const Color(0xFFFFFFFF);
      red = const Color(0xFFFB496F);
      // red = reduceSaturation(const Color(0xFFFF4C4C), saturationFactor);
      red50 = reduceSaturation(const Color(0xFF4C0000), saturationFactor);
      cream = reduceSaturation(const Color(0xFF8B6B48), saturationFactor);
      // yellow = reduceSaturation(const Color(0xFFD48806), saturationFactor);
      yellow = const Color(0xFFF6CC1E);
      brown = const Color(0xFFFA9B3E);
      // brown = reduceSaturation(const Color(0xFF8C5723), saturationFactor);
      grey = reduceSaturation(const Color(0xFF7A8C9E), saturationFactor);
      // background = const Color(0xFF131428); // Dark background
      background = const Color(0xFF121212); // Dark background

      // Adjusted Neutral Colors for better contrast
      neutral1 = const Color(0xFF0A0A0A); // Darkest neutral
      neutral2 = const Color(0xFF313030);
      neutral3 = const Color(0xFF4F4D74);
      neutral4 = const Color(0xFFA5A4C4);
      neutral5 = const Color(0xFFBEBBBB);
      neutral6 = const Color(0xFFEAEAEA);
      neutral7 = const Color(0xFFF8F8F8); // Lightest neutral

      harmoniGradient = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color(0xFF0BA9FF),
          Color(0xFF0BA9FF),
          // reduceSaturation(const Color(0xFF0D47A1), saturationFactor),
          // reduceSaturation(const Color(0xFF0BA9FF), saturationFactor),
          // reduceSaturation(const Color(0xFF1976D2), saturationFactor),
        ],
      );

      shadow1 = [];
      shadow3 = [];
      shadow6 = [];
      softShadow = [];
    } else {
      // Dark Overlay Style
      SystemChrome.setSystemUIOverlayStyle(dark);
      primary = const Color(0xFF4162FF);
      primary2 = const Color(0xFFB1E2FF);
      blue1 = const Color(0xFFF8F6FF);
      blue2 = const Color(0xFFE7F6FF);
      blue3 = const Color(0xFFE7F6FF);
      white = const Color(0xFFFFFFFF);
      black = const Color(0xFF000000);
      red = const Color(0xFFFF7272);
      red50 = const Color(0xFFFFECED);
      cream = const Color(0xFFCFB590);
      yellow = const Color(0xFFEEA721);
      brown = const Color(0xFFE6931B);
      grey = const Color(0xFF6A9FC5);
      // background = const Color(0xFFF7F9FA);
      background = const Color(0xFFF6F8FA);
      neutral1 = const Color(0xFFF8F8F8);
      neutral2 = const Color(0xFFEAEAEA);
      neutral3 = const Color(0xFFBEBBBB);
      neutral4 = const Color(0xFFA5A4C4);
      neutral5 = const Color(0xFF4F4D74);
      neutral6 = const Color(0xFF313030);
      neutral7 = const Color(0xFF0A0A0A);
      harmoniGradient = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFF057EFF), Color(0xFF4EBCFF)],
      );
      shadow1 = _shadow1;
      shadow3 = _shadow3;
      shadow6 = _shadow6;
      softShadow = _softShadow;
      // _saladThemes();
    }
    if (forceUpdate) {
      App.forceUpdate();
    }
  }

  static coffeeThemes() {
    _coffeeThemes();
    App.forceUpdate();
  }

  // ignore: unused_element
  static _saladThemes() {
    // Salad
    // Base Colors
    primary = const Color(0xFF4CAF50); // warna hijau segar
    primary2 = const Color(0xFF81C784); // warna hijau terang
    blue1 = const Color(0xFFF1F8E9); // warna hijau sangat terang
    blue2 = const Color(0xFFA5D6A7); // warna hijau muda
    blue3 = const Color(0xFFA5D6A7); // warna hijau muda
    white = const Color(0xFFFFFFFF); // tetap putih
    black = const Color(0xFF000000); // tetap hitam
    red = const Color(0xFFFF7043); // warna merah tomat
    red50 = const Color(0xFFFFE0E0); // warna merah muda
    cream = const Color(0xFFFFF3E0); // warna krem terang
    yellow = const Color(0xFFFFF176); // warna kuning cerah
    brown = const Color(0xFF8D6E63); // warna coklat tanah
    grey = const Color(0xFFBDBDBD); // warna abu-abu

    background =
        const Color(0xFFF1F8E9); // warna latar belakang hijau sangat terang
    // neutral Colors
    neutral1 = const Color(0xFFF9FBE7); // warna hijau sangat terang
    neutral2 = const Color(0xFFE8F5E9); // warna hijau terang
    neutral3 = const Color(0xFFC8E6C9); // warna hijau muda
    neutral4 = const Color(0xFFA5D6A7); // warna hijau muda
    neutral5 = const Color(0xFF66BB6A); // warna hijau cerah
    neutral6 = const Color(0xFF388E3C); // warna hijau gelap
    neutral7 = const Color(0xFF2E7D32); // warna hijau sangat gelap

    harmoniGradient = const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Color(0xFF4CAF50), Color(0xFF81C784)], // gradasi warna hijau
    );
  }

  // ignore: unused_element
  static _coffeeThemes() {
    // Coffee:
    // Base Colors
    primary = const Color(0xFF6F4E37); // warna kopi coklat tua
    primary2 = const Color(0xFFD2B48C); // warna kopi beige
    blue1 = const Color(0xFFEDE7E0); // warna off-white dengan sentuhan coklat
    blue2 = const Color(0xFFCBB79C); // warna coklat muda
    blue3 = const Color(0xFFCBB79C); // warna coklat muda
    white = const Color(0xFFFFFFFF); // tetap putih
    black = const Color(0xFF000000); // tetap hitam
    red = const Color(0xFFA0522D); // warna merah bata
    red50 = const Color(0xFFF4E1D2); // warna merah muda kecoklatan
    cream = const Color(0xFFD2B48C); // warna krem
    yellow = const Color(0xFFC19A6B); // warna kuning kecoklatan
    brown = const Color(0xFF8B4513); // warna coklat
    grey = const Color(0xFF8D918D); // warna abu-abu

    background = const Color(0xFFEDE7E0); // warna latar belakang yang lembut
    // neutral Colors
    neutral1 = const Color(0xFFF5F5DC); // warna beige
    neutral2 = const Color(0xFFE3DCC9); // warna krem
    neutral3 = const Color(0xFFC0C0C0); // warna abu-abu
    neutral4 = const Color(0xFFBDB76B); // warna khaki
    neutral5 = const Color(0xFF8B4513); // warna coklat
    neutral6 = const Color(0xFF4B3621); // warna coklat gelap
    neutral7 = const Color(0xFF2F1B0C); // warna coklat yang sangat gelap

    harmoniGradient = const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Color(0xFF6F4E37), Color(0xFFD2B48C)], // gradasi warna kopi
    );
  }

  static List<BoxShadow> softShadow = const [];
  static const List<BoxShadow> _softShadow = [
    BoxShadow(
      color: Color(0x024B4B4B),
      blurRadius: 2.21,
      offset: Offset(0, 0.25),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x044B4B4B),
      blurRadius: 5.32,
      offset: Offset(0, 0.60),
      spreadRadius: 0,
    ),
    // BoxShadow(
    //   color: Color(0x044B4B4B),
    //   blurRadius: 10.02,
    //   offset: Offset(0, 1.13),
    //   spreadRadius: 0,
    // ),
  ];
  static List<BoxShadow> shadow1 = const [];
  static const List<BoxShadow> _shadow1 = [
    BoxShadow(
      color: Color(0x024B4B4B),
      blurRadius: 2.21,
      offset: Offset(0, 0.25),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x044B4B4B),
      blurRadius: 5.32,
      offset: Offset(0, 0.60),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x044B4B4B),
      blurRadius: 10.02,
      offset: Offset(0, 1.13),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x064B4B4B),
      blurRadius: 17.87,
      offset: Offset(0, 2.01),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x074B4B4B),
      blurRadius: 33.42,
      offset: Offset(0, 3.76),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A4B4B4B),
      blurRadius: 80,
      offset: Offset(0, 9),
      spreadRadius: 0,
    )
  ];
  static List<BoxShadow> shadow3 = [];
  static final List<BoxShadow> _shadow3 = [
    BoxShadow(
      color: const Color(0xff62616E).withAlpha((0.04 * 255).toInt()),
      blurRadius: 135,
      offset: const Offset(0, 46),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xff62616E).withAlpha((0.0261 * 255).toInt()),
      blurRadius: 40.7,
      offset: const Offset(0, 13.87),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xff62616E).withAlpha((0.02 * 255).toInt()),
      blurRadius: 16.9,
      offset: const Offset(0, 5.76),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xff62616E).withAlpha((0.0139 * 255).toInt()),
      blurRadius: 6.11,
      offset: const Offset(0, 2.08),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> shadow6 = [];
  static final List<BoxShadow> _shadow6 = [
    const BoxShadow(
      blurRadius: 80,
      color: Color.fromRGBO(170, 164, 164, 0.12),
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 40.04,
      color: Color.fromRGBO(170, 164, 164, 0.0912),
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 24.12,
      color: Color.fromRGBO(170, 164, 164, 0.0782),
      offset: Offset(0, 1.21),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 15.46,
      color: Color.fromRGBO(170, 164, 164, 0.0685),
      offset: Offset(0, 0.77),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 10.02,
      color: Color.fromRGBO(170, 164, 164, 0.06),
      offset: Offset(0, 0.5),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 6.31,
      color: Color.fromRGBO(170, 164, 164, 0.0515),
      offset: Offset(0, 0.32),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 3.62,
      color: Color.fromRGBO(170, 164, 164, 0.0418),
      offset: Offset(0, 0.18),
      spreadRadius: 0,
    ),
    const BoxShadow(
      blurRadius: 1.59,
      color: Color.fromRGBO(170, 164, 164, 0.0288),
      offset: Offset(0, 0.08),
      spreadRadius: 0,
    ),
  ];
}

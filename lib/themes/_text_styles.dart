// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

extension TextStyleColorExtension on TextStyle {
  TextStyle withColor(Color? color) {
    return copyWith(color: this.color ?? color);
  }
}

class Ts {
  static TxtStyle text = TxtStyle();
  static HeadStyle heading = HeadStyle();
}

class TxtStyle {
  // XS
  final TextStyle xsLight = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w300,
    fontSize: 11,
    letterSpacing: 0,
  );

  final TextStyle xsRegular = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
    fontSize: 11,
    letterSpacing: 0,
  );

  final TextStyle xsMedium = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 0,
  );

  // S
  final TextStyle sLight = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w300,
    fontSize: 13,
    letterSpacing: 0,
    height: 1.25, // Adjust the height
  );

  final TextStyle sRegular = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    letterSpacing: 0,
    height: 1.25, // Adjust the height
  );

  final TextStyle sMedium = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    letterSpacing: 0,
    height: 1.25,
  );

  // M
  final TextStyle mLight = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w300,
      fontSize: 14,
      letterSpacing: 0,
      height: 20 / 14);

  final TextStyle mRegular = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0,
      height: 20 / 14);

  final TextStyle mMedium = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0,
      height: 20 / 14);

  // L
  final TextStyle lLight = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w300,
      fontSize: 16,
      letterSpacing: 0,
      height: 24 / 16);

  final TextStyle lRegular = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 0,
      height: 24 / 16);

  final TextStyle lMedium = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: 0,
      height: 24 / 16);
  final TextStyle lBold = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      letterSpacing: 0,
      height: 24 / 16);

  final TextStyle xlRegular = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w400,
      fontSize: 18,
      letterSpacing: 0);

  final TextStyle xlMedium = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w500,
      fontSize: 18,
      letterSpacing: 0);
  final TextStyle xlBold = const TextStyle(
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w700,
    fontSize: 1,
    letterSpacing: 0,
  );
}

class HeadStyle {
  // S
  final TextStyle small = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      letterSpacing: 0.5,
      height: 28 / 20);
  // M
  final TextStyle medium = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w600,
      fontSize: 30,
      letterSpacing: 0.5,
      height: 36 / 28);
  // L
  final TextStyle large = const TextStyle(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w600,
      fontSize: 40,
      letterSpacing: 0.5,
      height: 44 / 36);
}

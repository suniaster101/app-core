// 🐦 Flutter imports:
import 'package:appcore/services/_session_service.dart';
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// 📦 Package imports:

class Body extends StatefulWidget {
  const Body({super.key, this.child, this.color, this.showTexture = false});
  final Widget? child;
  final Color? color;
  final bool showTexture;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.14, -0.99),
            end: const Alignment(-0.14, 0.99),
            transform: const GradientRotation(0.9),
            colors: Session.i.isDarkMode
                ? [const Color(0xFF131428), const Color(0xFF131428)]
                // ? [const Color(0xFF8146B0), const Color(0xFF632D8D), const Color(0xff2A1749)]
                : [
                    widget.color ?? Themes.background,
                    widget.color ?? Themes.background
                  ],
          ),
        ),
        child: Stack(
          children: [
            if (Screen.isMobile || widget.showTexture)
              Positioned(
                bottom: Screen.isMobile ? 0 : null,
                top: Screen.isMobile ? null : 0,
                left: Screen.isMobile ? 0 : null,
                right: Screen.isMobile ? null : 0,
                child: SvgPicture.asset(
                  'assets/icons/sidebar/${Screen.isMobile ? "texture_bg.svg" : "texture_tablet.svg"}',
                  colorFilter: ColorFilter.mode(
                      Themes.primary.withAlpha((.6 * 255).toInt()),
                      BlendMode.srcIn),
                ),
              ),
            Positioned.fill(child: widget.child ?? Container()),
          ],
        ),
      ),
    );
  }
}

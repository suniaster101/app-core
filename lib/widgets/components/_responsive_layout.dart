import 'package:appcore/core.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, this.mobile, this.tablet, this.desktop});
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (Screen.isMobile) {
      return mobile ?? Container();
    } else if (Screen.isTablet) {
      return tablet ?? Container();
    }
    return desktop ?? Container();
  }
}

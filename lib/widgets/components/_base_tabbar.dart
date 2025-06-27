// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:

class BaseTabbar extends StatelessWidget {
  const BaseTabbar({
    super.key,
    this.padding,
    this.margin,
    this.color,
    required this.child,
    this.withShadow = true,
  });
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool withShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(left: 20, top: 10, right: 20),
      padding: padding ?? const EdgeInsets.all(5),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: color ?? Themes.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(38),
        ),
        shadows: withShadow ? Themes.shadow1 : [],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                outlineVariant: Colors.transparent,
                surfaceContainerLow: Colors.transparent,
              ),
        ),
        child: child,
      ),
    );
  }
}

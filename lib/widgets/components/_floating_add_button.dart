// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:appcore/widgets/components/_spacer_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({
    super.key,
    this.text,
    this.onTap,
    this.icon,
    this.showIcon = true,
    this.searchIcon,
  });
  final String? text;
  final VoidCallback? onTap;
  final Widget? icon;
  final bool showIcon;
  final Widget? searchIcon;
  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: () async {
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: (text?.isNotEmpty ?? false)
              ? showIcon
                  ? 12
                  : 30
              : 8,
          right: (text?.isNotEmpty ?? false)
              ? showIcon
                  ? 20
                  : 30
              : 8,
        ),
        constraints: const BoxConstraints(minHeight: 48),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.00, -0.00),
            end: const Alignment(1, 0),
            colors: Themes.harmoniGradient.colors,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(41),
          ),
          shadows: Themes.softShadow,
        ),
        child: Row(
          children: [
            if (showIcon)
              text?.isNotEmpty ?? false
                  ? Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Themes.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.50),
                        ),
                      ),
                      child: icon ??
                          SvgPicture.asset(
                            'assets/icons/ic_add.svg',
                            width: 24,
                            height: 24,
                          ),
                    )
                  : Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: searchIcon ??
                          SvgPicture.asset(
                            'assets/search.svg',
                            width: 24,
                            height: 24,
                          ),
                    ),
            if ((text?.isNotEmpty ?? false) && showIcon) const Width(6),
            Text(text ?? 'Category',
                style: Ts.text.mRegular.withColor(Themes.white))
          ],
        ),
      ),
    );
  }
}

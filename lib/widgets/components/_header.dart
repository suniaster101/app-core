// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:flutter/material.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader(
      {super.key,
      this.title,
      this.textColor,
      this.backgroundColor,
      this.child,
      this.leftActions,
      this.actions,
      this.showBack = false});
  final String? title;
  final Color? textColor;
  final Widget? leftActions;
  final Widget? child;
  final Widget? actions;
  final Color? backgroundColor;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    if (Screen.isMobile) {
      return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: backgroundColor ?? Themes.white,
          border: Border(
            bottom: BorderSide(color: Themes.neutral2, width: .5),
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                if (showBack)
                  Clickable(
                    onTap: () {
                      App.back();
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(
                          left: 15, right: 10, top: 5, bottom: 5),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                Container(
                  margin: Screen.isMobile
                      ? showBack
                          ? null
                          : const EdgeInsets.only(left: 15)
                      : const EdgeInsets.only(left: 55),
                  alignment: Screen.isMobile
                      ? Alignment.centerLeft
                      : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: child ??
                      Text(
                        title ?? 'Dashboard',
                        style: Ts.text.xlRegular
                            .withColor(textColor ?? Themes.neutral7),
                      ),
                ),
              ],
            ),
            if (actions != null)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: Screen.isMobile ? 15 : 20),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Themes.white.withOpacity(.6),
                    // border: const Border(
                    //   bottom: BorderSide(
                    //     width: 1,
                    //     color: Color(0xFFE4E4E4),
                    //   ),
                    // ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      actions ?? Container(width: 30),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}

class TabletHeader extends StatelessWidget {
  const TabletHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.trailing,
  });
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    if (Screen.isMobile) {
      return const SizedBox();
    }
    return Container(
      height: 75 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Themes.white,
        border: Border(
          bottom: BorderSide(color: Themes.neutral2, width: .5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading ??
              const SizedBox(
                width: 5,
              ),
          Expanded(
            child: titleWidget ??
                Text(
                  title ?? "",
                  style: Ts.text.lRegular.withColor(Themes.neutral7),
                ),
          ),
          trailing ??
              const SizedBox(
                width: 5,
              ),
        ],
      ),
    );
  }
}

// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:appcore/widgets/willpop.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return WillPop(
      onWillPop: (canPop) async {
        if (canPop) {
          App.back();
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.isMobile ? 20 : 20, vertical: 20),
          constraints:
              Screen.isMobile ? null : const BoxConstraints(maxWidth: 450),
          decoration: ShapeDecoration(
            color: Themes.white,
            shape: RoundedRectangleBorder(
              borderRadius: Screen.isTablet
                  ? const BorderRadius.all(Radius.circular(15))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Screen.isMobile)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Themes.neutral3),
                  ),
                ),
              child ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

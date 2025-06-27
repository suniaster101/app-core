// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:flutter/material.dart';
// 🌎 Project imports:

class RadioBtn extends StatelessWidget {
  const RadioBtn(
      {super.key, this.value = false, this.size = 20, this.onChanged});
  final bool value;
  final double size;
  final Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () {
        onChanged?.call(!value);
      },
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFE6F5FF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.75, color: Color(0xFFB1E2FF)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size * 12 / 20,
            height: size * 12 / 20,
            decoration: ShapeDecoration(
              color: value ? Themes.primary : Colors.transparent,
              shape: const OvalBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

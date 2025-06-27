// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:flutter/material.dart';
// 🌎 Project imports:

class SwitchBtn extends StatelessWidget {
  const SwitchBtn({super.key, this.value = false, this.onChanged});
  final bool value;
  final Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () {
        onChanged?.call(!value);
      },
      child: AnimatedContainer(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: value ? Themes.primary : Themes.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Themes.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class CheckBoxBtn extends StatelessWidget {
  const CheckBoxBtn({
    super.key,
    this.value = false,
    this.onChanged,
  });
  final bool value;
  final Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () {
        onChanged?.call(!value);
      },
      child: AnimatedContainer(
        height: 22,
        width: 22,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: value ? Themes.primary : Colors.transparent,
          border: Border.all(
              color: Themes.primary.withAlpha((.8 * 255).toInt()), width: 1.25),
          borderRadius: BorderRadius.circular(6),
        ),
        child: value
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              )
            : null,
      ),
    );
  }
}

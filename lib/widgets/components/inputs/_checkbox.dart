// 🐦 Flutter imports:
import 'package:appcore/widgets/components/_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// 📦 Package imports:

class ChBox extends StatefulWidget {
  const ChBox({super.key, this.value = false, this.onChanged});
  final bool value;
  final Function(bool value)? onChanged;

  @override
  State<ChBox> createState() => _ChBoxState();
}

class _ChBoxState extends State<ChBox> {
  bool isChecked = false;
  @override
  void initState() {
    isChecked = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChBox oldWidget) {
    if (widget.value != oldWidget.value) {
      setState(() {
        isChecked = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () {
        widget.onChanged?.call(!isChecked);
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isChecked
            ? SvgPicture.asset(
                key: const ValueKey('checked'),
                'assets/icons/isChecked=True.svg',
                width: 20,
              )
            : Container(
                key: const ValueKey('unchecked'),
                width: 20,
                height: 20,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE6F5FF),
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 0.75, color: Color(0xFFB1E2FF)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
      ),
    );
  }
}

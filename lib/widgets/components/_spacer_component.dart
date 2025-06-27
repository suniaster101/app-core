// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  const Height(this.spaces, {super.key});
  final double spaces;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: spaces,
    );
  }
}

extension SizeDoubleExt on double {
  Widget get height => SizedBox(height: this);
  Widget get width => SizedBox(width: this);
}

extension SizeIntExt on int {
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
}

class Width extends StatelessWidget {
  const Width(this.spaces, {super.key});
  final double spaces;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spaces,
    );
  }
}

class Hr extends StatelessWidget {
  const Hr({super.key, this.height, this.color});
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: (height ?? 0) + 1,
      child: Row(
        children: List.generate(
            51,
            (index) => Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: index % 2 == 1
                          ? Colors.transparent
                          : color ?? Themes.neutral2,
                    ),
                  ),
                )),
      ),
    );
  }
}

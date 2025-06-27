// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/bottomsheets/_base_dialog.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:appcore/widgets/components/_spacer_component.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteConfirmationSheet extends StatelessWidget {
  const DeleteConfirmationSheet(
      {super.key, this.title, this.subtitle, this.onDelete});
  final String? title;
  final String? subtitle;
  final Future<void> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(children: [
        SvgPicture.asset('assets/pos/delete.svg', width: 167),
        const Height(27),
        Text(
          title ?? 'Delete Product',
          style: Ts.text.xlMedium.withColor(Themes.neutral7),
        ),
        const Height(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subtitle ??
                "You're going to delete \"Grilled Chicken Steak\" product. Are you sure?",
            style: Ts.text.mLight.withColor(Themes.neutral5),
            textAlign: TextAlign.center,
          ),
        ),
        const Height(45),
        Row(
          children: [
            Expanded(
                child: SecondaryButton(
              text: 'No, Keep It.',
              onTap: () async {
                App.back();
              },
            )),
            const Width(15),
            Expanded(
                child: DangerButton(
              text: 'Yes, Remove!',
              onTap: () async {
                if (onDelete != null) {
                  App.back();
                  onDelete?.call();
                } else {
                  App.back();
                }
              },
            )),
          ],
        )
      ]),
    );
  }
}

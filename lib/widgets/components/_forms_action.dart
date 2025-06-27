// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:appcore/widgets/components/_spacer_component.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:flutter/material.dart';

class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    this.title,
    this.subtitle,
    this.enableSubmit = true,
    this.enableAction = true,
    this.cancelText,
    this.submitText,
    this.onCancel,
    this.onSubmit,
  });
  final bool enableSubmit;
  final bool enableAction;
  final String? title;
  final String? subtitle;
  final String? cancelText;
  final String? submitText;
  final Future<void> Function()? onCancel;
  final Future<void> Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Screen.isMobile)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "Add Item",
                    style: Ts.text.lMedium.withColor(Themes.neutral6),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      subtitle ?? "Please add information below",
                      style: Ts.text.sLight.withColor(Themes.neutral5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        enableAction
            ? Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        padding:
                            Screen.isMobile ? null : const EdgeInsets.all(10),
                        text: cancelText ?? "Cancel",
                        textStyle: Screen.isMobile ? null : Ts.text.lRegular,
                        onTap: onCancel ??
                            () async {
                              App.back();
                            },
                      ),
                    ),
                    Screen.isMobile ? const Width(16) : const Width(10),
                    Expanded(
                      child: PrimaryButton(
                        padding:
                            Screen.isMobile ? null : const EdgeInsets.all(10),
                        enabled: enableSubmit,
                        text: submitText ?? "Submit",
                        onTap: onSubmit,
                        textStyle: Screen.isMobile ? null : Ts.text.lRegular,
                      ),
                    ),
                  ],
                ),
              )
            : const Height(44),
      ],
    );
  }
}

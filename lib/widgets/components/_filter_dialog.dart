// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/bottomsheets/_base_dialog.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:appcore/widgets/components/_spacer_component.dart';
import 'package:appcore/widgets/components/inputs/_radio_button.dart';
import 'package:appcore/widgets/harmoni.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.options,
    this.title,
    this.subtitle,
    this.currentValue,
  });
  final String? title;
  final String? subtitle;
  final String? currentValue;
  final Map<String, String> options;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String value = widget.currentValue ?? "";
  @override
  Widget build(BuildContext context) {
    final values = widget.options.keys.toList();
    final text = widget.options.values.toList();
    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Height(20),
          Text(
            widget.title ?? 'Sort Categories',
            style: Ts.text.lMedium.withColor(Themes.neutral7),
          ),
          const Height(2),
          Text(
            widget.subtitle ??
                'Please select one of the parameters below to sort categories',
            style: Ts.text.sLight.withColor(Themes.neutral5),
          ),
          const Height(20),
          Divider(
            color: Themes.neutral1,
            height: 20,
            thickness: 1,
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: Clickable(
                      onTap: () {
                        setState(() {
                          value = values[index * 2];
                        });
                      },
                      child: Row(
                        children: [
                          RadioBtn(
                            value: values[index * 2] == value,
                            onChanged: (val) {
                              setState(() {
                                value = values[index * 2];
                              });
                            },
                          ),
                          const Width(10),
                          Expanded(
                            child: Text(
                              text[index * 2],
                              style: Ts.text.sLight.withColor(Themes.neutral6),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Width(28),
                  Expanded(
                    child: Clickable(
                      onTap: () {
                        setState(() {
                          value = values[index * 2 + 1];
                        });
                      },
                      child: Row(
                        children: [
                          RadioBtn(
                            value: values[index * 2 + 1] == value,
                          ),
                          const Width(10),
                          Expanded(
                            child: Text(
                              text[index * 2 + 1],
                              style: Ts.text.sLight.withColor(Themes.neutral6),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Themes.neutral1,
              height: 20,
              thickness: 1,
            ),
            itemCount: (values.length) ~/ 2,
          ),
          const Height(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    text: "Cancel",
                    onTap: () async {
                      // Get.back();
                      App.back();
                    },
                  ),
                ),
                const Width(16),
                Expanded(
                  child: PrimaryButton(
                    text: "Apply",
                    onTap: () async {
                      App.back(result: value);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 🐦 Flutter imports:

import 'package:appcore/core.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({
    super.key,
    this.showFull = false,
    this.alignment,
  });
  final bool showFull;
  final AlignmentGeometry? alignment;

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String _lang = "EN";
  // late String _lang = (context.locale.languageCode).toUpperCase();

  final _langMap = {
    "EN": "assets/translations/us.svg",
    "ID": "assets/translations/id.svg",
  };
  final _langName = {
    "EN": "English (US)",
    "ID": "Bahasa Indonesia",
  };
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        customButton: Container(
          alignment: widget.alignment ?? Alignment.centerRight,
          constraints: const BoxConstraints(maxWidth: 180),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: Themes.shadow6,
                ),
                child: SvgPicture.asset(
                  _langMap[_lang] ?? "assets/dine-svgrepo-com.svg",
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                ),
              ),
              const Width(5),
              Text(
                widget.showFull ? _langName[_lang] ?? "" : _lang,
                style: Ts.text.mRegular.withColor(Themes.neutral5),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: Themes.neutral5.withAlpha((.8 * 255).toInt()),
              ),
            ],
          ),
        ),
        items: _langMap.keys
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    _langName[item] ?? "",
                  ),
                ))
            .toList(),
        value: _lang,
        onChanged: (String? value) {
          setState(() {
            _lang = value ?? _lang;
            // var locale = const Locale('en', 'US');
            // if (value == "ID") {
            //   locale = const Locale('id', 'ID');
            // }
            // Session.i.setLanguage(languageCode: _lang.toLowerCase());
            // context.setLocale(locale);
          });
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
          elevation: 0,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 36,
        ),
        style: Ts.text.sRegular.withColor(Themes.white),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Themes.neutral5,
          ),
        ),
      ),
    );
  }
}

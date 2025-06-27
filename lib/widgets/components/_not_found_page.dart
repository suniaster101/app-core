// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({
    super.key,
    this.title,
    this.subtitle,
    this.cta,
    this.onTap,
  });
  final String? title;
  final String? subtitle;
  final String? cta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/404.png"),
          const Height(20),
          Text(
            title ?? "Whoops! you’re lost.",
            style: Ts.text.lMedium.withColor(Themes.neutral6),
            textAlign: TextAlign.center,
          ),
          const Height(5),
          Text(
            subtitle ??
                "Sorry, we couldn’t find what you were looking or the page no longer exist.",
            style: Ts.text.mLight.withColor(Themes.neutral5),
            textAlign: TextAlign.center,
          ),
          const Height(20),
          Clickable(
            onTap: onTap,
            child: Text(
              cta ?? "Back to Home",
              style: Ts.text.mLight.withColor(Themes.primary).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Themes.primary,
                  ),
            ),
          ),
          const Height(30),
        ],
      ),
    );
  }
}

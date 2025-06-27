// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/widgets/components/_spacer_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.isSearching = false,
    this.title,
    this.subtitle,
    this.icon,
    this.cta,
  });
  final bool isSearching;
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final Widget? cta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: .75,
            child: isSearching
                ? SvgPicture.asset("assets/empty_state/search_no_result.svg")
                : icon ??
                    Image.asset(
                      "assets/ic_folder.png",
                      width: 250,
                    ),
          ),
          // const Height(20),
          Text(
            isSearching ? "No Results" : title ?? "Ready to Organize?",
            style: Ts.text.lMedium
                .withColor(Themes.neutral6)
                .copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const Height(10),
          Text(
            isSearching
                ? "Sorry, there are no results for this search, Please try another phrase"
                : subtitle ?? "Create your First Category Now!",
            style: Ts.text.lLight.withColor(Themes.neutral4),
            textAlign: TextAlign.center,
          ),
          const Height(36),
          if (cta != null && !isSearching)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cta!],
            ),
        ],
      ),
    );
  }
}

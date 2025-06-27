// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RevenueStatistics extends StatelessWidget {
  const RevenueStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return HarmoniCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            left: -28,
            top: -121,
            child: Container(
              width: 186,
              height: 186,
              decoration: ShapeDecoration(
                color: Themes.primary.withAlpha((.1 * 255).toInt()),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Revenue',
                            style:
                                Ts.text.xsRegular.withColor(Themes.neutral5)),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.only(left: 7, right: 4),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Themes.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text('13%',
                              style: Ts.text.xsRegular.withColor(Themes.red)),
                        ),
                      ],
                    ),
                    const Height(5),
                    RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            style: TextStyle(color: Themes.neutral7),
                            children: [
                              TextSpan(text: 'Rp', style: Ts.text.xsLight),
                              TextSpan(
                                  text: Format.currency(765980),
                                  style: Ts.heading.small)
                            ]))
                  ],
                ),
                const Width(37),
                const Expanded(child: RevenueChart()),
              ],
            ),
          ),
          // Positioned(
          //     right: 10.58,
          //     top: 11.08,
          //     child: SvgPicture.asset(
          //       'assets/icons/bar_chart_sprinkle.svg',
          //       width: 22.39,
          //       height: 20,
          //     ))
        ],
      ),
    );
  }
}

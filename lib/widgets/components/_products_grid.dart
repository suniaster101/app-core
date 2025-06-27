// 🐦 Flutter imports:
import 'package:appcore/core.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    this.amount = 0,
    this.title,
    this.badgeText,
    this.imageUrl,
    this.price,
    this.discount,
    this.isGrid = true,
    this.onTap,
  });
  final int amount;
  final String? title;
  final bool isGrid;
  final String? imageUrl;
  final String? badgeText;
  final double? price;
  final double? discount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.contain,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: isGrid ? 167.50 : 300,
                height: isGrid ? 188 : 70,
                padding: isGrid ? EdgeInsets.zero : const EdgeInsets.all(5),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Themes.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: Themes.softShadow,
                ),
                child: Flex(
                  direction: isGrid ? Axis.vertical : Axis.horizontal,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.all(isGrid ? 8 : 0),
                      decoration: ShapeDecoration(
                        color: Themes.primary.withAlpha((.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(isGrid ? 0 : 4)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isGrid ? 6 : 4),
                        child: AspectRatio(
                          aspectRatio: isGrid ? 167.90 / 135 : 1,
                          child: CachedImage(
                            imageUrl: imageUrl ?? '',
                            width: isGrid ? 167.5 : 60,
                            height: isGrid ? 135 : 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title ?? 'Chicken Steak',
                              style:
                                  Ts.text.sRegular.withColor(Themes.neutral6),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            isGrid ? const Height(3) : const Height(0),
                            if (!isGrid)
                              badgeText != null
                                  ? Text(badgeText ?? "",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11,
                                        letterSpacing: 0,
                                        color: Themes.neutral4,
                                      ))
                                  : const SizedBox(
                                      height: 18,
                                    ),
                            isGrid
                                ? Row(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Themes.neutral6),
                                            children: [
                                              TextSpan(
                                                  text: 'Rp',
                                                  style: Ts.text.xsLight
                                                      .withColor(Themes.neutral6
                                                          .withAlpha((0.5 * 255)
                                                              .toInt()))),
                                              TextSpan(
                                                  text: Format.currency(
                                                      price ?? 0),
                                                  style: Ts.text.mRegular)
                                            ]),
                                      ),
                                    ],
                                  )
                                : const Height(1), //const Spacer(),
                            if (!isGrid)
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      style: TextStyle(color: Themes.neutral6),
                                      children: [
                                        TextSpan(
                                          text: 'Rp',
                                          style: Ts.text.xsLight
                                              .withColor(Themes.neutral6)
                                              .copyWith(fontSize: 10),
                                        ),
                                        TextSpan(
                                          text:
                                              "${Format.currency((price ?? 0) - (discount ?? 0))} ",
                                          style: Ts.text.xsRegular
                                              .withColor(Themes.neutral6),
                                        ),
                                        if (discount != null)
                                          TextSpan(
                                            text:
                                                "Rp${Format.currency(price ?? 0)}",
                                            style: Ts.text.xsLight
                                                .withColor(Themes.neutral4)
                                                .copyWith(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          ),
                                      ]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // if (!isGrid && amount != 0)
              Positioned(
                bottom: 10,
                right: 10,
                child: Clickable(
                  onTap: () {},
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Themes.white, //.withValues(alpha:0.7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Themes.grey.withAlpha(
                                (amount != 0 ? .2 : .2 * 255)
                                    .toInt()), //.withValues(alpha:0.7),
                          ),
                          child: amount != 0
                              ? Text(
                                  "${amount > 9 ? '9+' : amount}",
                                  style:
                                      Ts.text.xsRegular.withColor(Themes.grey),
                                )
                              : SvgPicture.asset(
                                  "assets/shopping-bag.svg",
                                  width: 10,
                                  colorFilter: ColorFilter.mode(
                                      Themes.grey, BlendMode.srcIn),
                                  // color: Themes.white,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of 'extensions.dart';

extension ColumnAnimationExtension on Column {
  Widget animate({
    Duration? duration,
    Duration? delay,
    bool moveVertical = false,
    bool varyDuration = true,
    double power = 2.5, // Faktor eksponensial
  }) {
    int totalItems = children.length;
    int minDuration = 250;
    int maxDuration = 500;

    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children.asMap().entries.map((entry) {
          int index = entry.key;
          Widget widget = entry.value;

          int itemDuration = varyDuration
              ? (minDuration +
                      ((maxDuration - minDuration) *
                          math.pow(
                              (index / (totalItems - 1)).clamp(0, 1), power)))
                  .toInt()
              : (duration ?? const Duration(milliseconds: 300)).inMilliseconds;

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: itemDuration),
            delay: delay ?? const Duration(milliseconds: 25),
            child: SlideAnimation(
              verticalOffset: moveVertical ? 50 : null,
              horizontalOffset: moveVertical ? null : 50,
              curve: Curves.easeOut,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                child: widget,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

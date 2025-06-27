// 🎯 Dart imports:
import 'dart:io';

import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:

class Button extends StatefulWidget {
  const Button(
      {super.key,
      this.padding,
      this.backgroundColor,
      this.duration,
      this.child,
      this.contents,
      this.text,
      this.borderRadius = 0,
      this.border,
      this.width,
      this.height,
      this.enabled = true,
      this.boxShadow,
      this.onTap})
      : defaultPadding = const EdgeInsets.all(0),
        color = null,
        defaultBackgroundColor = Colors.transparent;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry defaultPadding;
  final Color? color;
  final bool enabled;
  final Color? backgroundColor;
  final Color defaultBackgroundColor;
  final Duration? duration;

  final Widget? child;
  final Widget? contents;
  final String? text;
  final Future<void> Function()? onTap;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final BoxShadow? boxShadow;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late Animation<double> _scale;
  late AnimationController _controller;
  bool _isLoading = false;
  bool _hasDarkBackground = false;
  final GlobalKey _keys = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 200),
    );

    if (widget.color == null) {
      final perceivedBrightness =
          (widget.backgroundColor ?? widget.defaultBackgroundColor)
              .computeLuminance();
      _hasDarkBackground = perceivedBrightness < 0.5;
    }
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox childRenderBox =
        _keys.currentContext?.findRenderObject() as RenderBox;
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: _keys,
      onPointerDown: (PointerDownEvent event) {
        if (!widget.enabled) return;
        if (_isLoading) return;
        _controller.forward();
      },
      onPointerUp: (PointerUpEvent event) async {
        if (!widget.enabled) return;
        if (_isLoading) return;
        try {
          _controller.reverse();
          if (_isOutsideChildBox(event.position)) return;
          setState(() {
            _isLoading = true;
          });
          (widget.onTap ?? () => Future.delayed(const Duration(seconds: 1)))
              .call()
              .then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        } catch (e) {
          Log.e(e);
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ScaleTransition(
          scale: _scale,
          child: Stack(
            children: [
              widget.child ??
                  Container(
                      alignment: Alignment.center,
                      height: widget.height,
                      width: widget.width ?? double.maxFinite,
                      padding: widget.padding ??
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            widget.boxShadow ??
                                BoxShadow(
                                    color: const Color(0xffDDDADA)
                                        .withAlpha((0.4 * 255).toInt()),
                                    offset: const Offset(0, 4),
                                    blurRadius: 17),
                          ],
                          border: widget.border,
                          color: widget.backgroundColor ??
                              widget.defaultBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius ?? 15)),
                      child: widget.contents ??
                          Text(
                            widget.text ?? '',
                            style: Ts.text.lMedium.withColor(widget.color ??
                                (_hasDarkBackground
                                    ? Themes.white
                                    : Themes.black)),
                          )),
              Positioned.fill(
                  child: _isLoading
                      ? SpinKitPulse(
                          color:
                              _hasDarkBackground ? Themes.white : Themes.black,
                          size: 200,
                        )
                      : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}

class Clickable extends StatefulWidget {
  const Clickable({
    super.key,
    this.child,
    this.onTap,
  });
  final VoidCallback? onTap;
  final Widget? child;

  @override
  State<Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<Clickable> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        if (Platform.isWindows) {
          setState(() {
            _isHovering = true;
          });
        }
      },
      onExit: (event) {
        if (Platform.isWindows) {
          setState(() {
            _isHovering = false;
          });
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _isHovering ? .98 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      this.text,
      this.child,
      this.enabled = true,
      this.onTap,
      this.height,
      this.padding,
      this.textStyle});
  final String? text;
  final double? height;
  final bool enabled;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Button(
      enabled: enabled,
      onTap: enabled
          ? () async {
              try {
                await onTap?.call();
              } catch (_) {}
            }
          : null,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height ?? 58,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              // begin: enabled ? Alignment.topCenter : Alignment.centerLeft,
              // end: enabled ? Alignment.bottomCenter : Alignment.centerRight,
              // end: Alignment(-1.00, -0.00),
              // begin: Alignment(1, 0),
              // colors: [Color(0xFF349BFD), Color(0xFF1B64A9)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: enabled
                  // ? [const Color(0xFF51A1EC), const Color(0xFF0779E4)]
                  ? Themes.harmoniGradient.colors
                  : [const Color(0xFF646464), const Color(0xFF909090)],
            ),
            // color: Themes.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: child ??
              Text(
                text ?? 'Submit',
                textAlign: TextAlign.center,
                style: (Screen.isMobile
                        ? (textStyle ?? Ts.text.lMedium)
                        : Ts.text.mLight)
                    .withColor(Colors.white),
              ),
        ),
      ),
    );
  }
}

class DangerButton extends StatelessWidget {
  const DangerButton({super.key, this.text, this.child, this.onTap});
  final String? text;
  final Widget? child;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: () async {
        try {
          await onTap?.call();
        } catch (_) {}
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-1.00, -0.00),
            end: Alignment(1, 0),
            colors: [Color(0xFFFD7878), Color.fromARGB(255, 246, 97, 97)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: child ??
            Text(text ?? 'Submit',
                textAlign: TextAlign.center,
                style: Ts.text.lMedium.withColor(Themes.white)),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    this.text,
    this.onTap,
    this.padding,
    this.textStyle,
  });
  final String? text;
  final Future<void> Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: () async {
        try {
          await onTap?.call();
        } catch (_) {}
      },
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 0.50,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFF51A1EC),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: Themes.harmoniGradient.colors,
              // tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text(
            text ?? 'Submit',
            textAlign: TextAlign.center,
            style: (Screen.isMobile
                    ? (textStyle ?? Ts.text.lMedium)
                    : Ts.text.mLight)
                .withColor(Colors.white),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.text,
    this.color,
    this.onTap,
    this.child,
  });
  final String? text;
  final Color? color;
  final Future<void> Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: () async {
        try {
          await onTap?.call();
        } catch (_) {}
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: color ?? Themes.neutral2.withAlpha((0.5 * 255).toInt()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: child ??
            Text(text ?? 'Submit',
                textAlign: TextAlign.center,
                style: Ts.text.lMedium.withColor(Themes.neutral5)),
      ),
    );
  }
}

class SpinKitPulse extends StatefulWidget {
  const SpinKitPulse({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(seconds: 1),
    this.controller,
  }) : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitPulse> createState() => _SpinKitPulseState();
}

class _SpinKitPulseState extends State<SpinKitPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();
    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 1.0 - _animation.value,
        child: Transform.scale(
          scale: _animation.value,
          child: SizedBox.fromSize(
            size: Size.square(widget.size),
            child: _itemBuilder(0),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.color));
}

class HarmoniCard extends StatelessWidget {
  const HarmoniCard({super.key, this.color, this.child, this.padding});
  final Color? color;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: color ?? Themes.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: Themes.softShadow,
      ),
      child: child,
    );
  }
}

// 🐦 Flutter imports:
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/components/_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
// 📦 Package imports:

class InputController extends TextEditingController {
  InputController({super.text});
  @override
  String get text => super.text.trim();
  String get getNum => super.text.replaceAll(RegExp(r'[^0-9\.\,]'), "");
}

extension ClearNumericString on String? {
  double? toFloat() {
    if (this?.contains(".") ?? false) {
      return double.tryParse((this ?? "").replaceAll(RegExp(r'[^0-9]'), ""));
    }
    return double.tryParse((this ?? "")); //.replaceAll(RegExp(r'[^0-9]'), ""));
  }

  int? toInt() {
    return int.tryParse((this ?? "").replaceAll(RegExp(r'[^0-9]'), ""));
  }
}

class FormInputValidator extends StatelessWidget {
  const FormInputValidator({super.key, this.validator, this.textAlign});
  final String? Function()? validator;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        return validator?.call();
      },
      builder: (field) {
        if (field.hasError) {
          return Text(
            field.errorText!,
            style: Ts.text.sLight.withColor(Themes.red),
            textAlign: textAlign ?? TextAlign.start,
          );
        }
        return const SizedBox();
      },
    );
  }
}

class ClickableInput extends StatelessWidget {
  const ClickableInput({
    super.key,
    this.onTap,
    this.child,
  });
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? const SizedBox(),
        Positioned.fill(
          child: Clickable(
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      this.controller,
      this.label,
      this.hintText,
      this.minLines,
      this.maxLines,
      this.maxLength,
      this.obscureText = false,
      this.readOnly = false,
      this.isOptional = false,
      this.showCounterOnTop = true,
      this.enabled = true,
      this.prefixIcon,
      this.suffixIcon,
      this.focusNode,
      this.onChanged,
      this.validator,
      this.onFieldSubmitted,
      this.textAlign = TextAlign.start,
      this.inputFormatters,
      this.keyboardType,
      this.contentPadding,
      this.suffixIconBuilder});
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool showCounterOnTop;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final String? Function(String value)? validator;
  final void Function(String value)? onChanged;
  final Function(String)? onFieldSubmitted;

  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? Function(bool obscured)? suffixIconBuilder;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  TextEditingController? controller;
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText;

    controller ??= widget.controller ?? TextEditingController();
    if (widget.showCounterOnTop) {
      controller!.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    controller = widget.controller ?? controller;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: (widget.label != null)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Text(
                            widget.label ?? '',
                            textAlign: TextAlign.left,
                            style: Ts.text.sRegular.withColor(Themes.neutral7),
                          ),
                          if (!widget.isOptional)
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Text(
                                '*',
                                textAlign: TextAlign.left,
                                style: Ts.text.sRegular.withColor(Themes.red),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
            if (widget.maxLength != null && widget.showCounterOnTop)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '${controller?.text.length ?? 0}/${widget.maxLength}',
                  textAlign: TextAlign.right,
                  style: Ts.text.sLight.withColor(Themes.neutral3),
                ),
              ),
          ],
        ),
        TextFormField(
          focusNode: widget.focusNode,
          controller: controller,
          obscureText: obscureText,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          textAlign: widget.textAlign,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: (value) {
            return widget.enabled ? widget.validator?.call(value ?? '') : null;
          },
          onTapOutside: (event) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          keyboardType: widget.keyboardType,
          style: Ts.text.sLight
              .withColor(widget.enabled ? Themes.neutral6 : Themes.neutral4),
          inputFormatters: widget.inputFormatters ??
              (widget.keyboardType == TextInputType.number
                  ? [IntTextInputFormatter(decimalRange: 0)]
                  : null),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (widget.contentPadding?.horizontal ?? 25) / 2),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null ||
                    widget.suffixIconBuilder != null
                ? InkWell(
                    onTap: widget.suffixIconBuilder != null
                        ? () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              (widget.contentPadding?.horizontal ?? 25) / 2),
                      child: widget.suffixIconBuilder?.call(obscureText) ??
                          widget.suffixIcon,
                    ),
                  )
                : null,
            counterText: widget.showCounterOnTop ? '' : null,
            prefixIconConstraints: BoxConstraints(
                maxHeight: (widget.contentPadding?.vertical ??
                    25 + ((Ts.text.sLight.fontSize ?? 0) * 1.5))),
            suffixIconConstraints: BoxConstraints(
                maxHeight: (widget.contentPadding?.vertical ??
                    25 + ((Ts.text.sLight.fontSize ?? 0) * 1.5))),
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(vertical: Screen.isMobile ? 15 : 18),
            prefix: widget.prefixIcon != null
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: Screen.isMobile ? 15 : 18)),
            suffix: widget.suffixIcon != null
                ? null
                : Padding(
                    padding: EdgeInsets.only(right: Screen.isMobile ? 15 : 18)),
            isDense: true,
            hintText: widget.hintText,
            fillColor: widget.enabled
                ? Themes.primary.withAlpha((.07 * 255).toInt())
                : Themes.neutral2.withAlpha((.4 * 255).toInt()),
            filled: true,
            hintStyle: Ts.text.sLight.withColor(Themes.neutral4),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              // borderSide: BorderSide(width: 0.25, color: Themes.neutral2),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
              // BorderSide(width: 0.25, color: Themes.neutral3.withValues(alpha:.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: Themes.neutral3.withValues(alpha:.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: Themes.primary2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: Themes.red),
            ),
            errorStyle: Ts.text.sLight.withColor(Themes.red),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.75, color: Themes.red),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectOptions extends StatefulWidget {
  const SelectOptions(
      {super.key,
      required this.data,
      this.label,
      this.labels,
      this.labelColor,
      this.suffixIcon,
      this.prefixIcon,
      this.borderRadius,
      this.borderColor,
      this.currentValue,
      required this.onChanged,
      this.contentPadding,
      this.hintText});
  final List<String> data;
  final List<String>? labels;
  final String? currentValue;
  final String? label;
  final double? borderRadius;
  final String? hintText;

  final Color? labelColor;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String? value) onChanged;

  @override
  State<SelectOptions> createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.label != null)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(widget.label ?? '',
                    textAlign: TextAlign.left,
                    style: Ts.text.sRegular.withColor(Themes.neutral7)),
              )
            : const SizedBox(),
        DropdownButtonFormField<String>(
          value: widget.currentValue,
          iconSize: 20,
          isDense: true,
          isExpanded: true,
          alignment: AlignmentDirectional.center,
          style: Ts.text.mLight.withColor(Themes.neutral6),
          onChanged: (String? value) {
            widget.onChanged(value);
          },
          icon: SvgPicture.asset(
            'assets/icons/ic_chevron-down.svg',
            width: 20,
          ),
          items: [
            for (var i = 0; i < widget.data.length; i++)
              DropdownMenuItem<String>(
                value: widget.data[i],
                child: Text(
                  widget.labels != null ? widget.labels![i] : widget.data[i],
                  style: Ts.text.mLight.withColor(Themes.neutral6),
                ),
              )
          ],
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (widget.contentPadding?.horizontal ?? 25) / 2),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            counterText: '',
            prefixIconConstraints: BoxConstraints(
                maxHeight: (widget.contentPadding?.vertical ??
                    25 + ((Ts.text.sLight.fontSize ?? 0) * 1.5))),
            contentPadding: widget.contentPadding ?? const EdgeInsets.all(12.5),
            isDense: true,
            hintText: widget.hintText,
            fillColor: Themes.primary.withAlpha((.1 * 255).toInt()),
            filled: true,
            hintStyle: Ts.text.mLight.withColor(Themes.neutral4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: widget.borderColor ?? Themes.neutral3.withValues(alpha:.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: widget.borderColor ?? Themes.neutral3.withValues(alpha:.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.25, color: widget.borderColor ?? Themes.primary2),
            ),
          ),
        ),
      ],
    );
  }
}

class InputOptions<T> extends StatelessWidget {
  const InputOptions(
      {super.key,
      required this.data,
      this.label,
      this.labels,
      this.border = false,
      this.currentValue,
      required this.onChanged,
      this.hintText,
      this.validator,
      this.isOptional = false,
      this.backgroundColor,
      this.labelGap,
      this.labelColor,
      this.labelStyle,
      this.contentPadding,
      this.keyboardType,
      this.prefixIcon,
      this.suffixIcon,
      this.suffixIconBuilder});
  final List<T> data;
  final List<String>? labels;
  final bool border;
  final bool isOptional;
  final String? hintText;
  final T? currentValue;
  final String? label;
  final Color? labelColor;
  final Color? backgroundColor;
  final double? labelGap;
  final String? Function(T? value)? validator;
  final TextStyle? labelStyle;

  final Function(T? value) onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? Function(bool obscured)? suffixIconBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: label != null,
          child: Row(
            children: [
              Text(
                label ?? '',
                style:
                    labelStyle ?? Ts.text.sRegular.withColor(Themes.neutral7),
              ),
              if (!isOptional)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    '*',
                    textAlign: TextAlign.left,
                    style: Ts.text.sRegular.withColor(Themes.red),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: labelGap ?? (label != null ? 5 : 0),
        ),
        SizedBox(
          height: 45,
          child: DropdownButtonFormField<T>(
            validator: validator,
            borderRadius: BorderRadius.circular(6),
            value: currentValue,
            isExpanded: true,
            isDense: true,
            alignment: AlignmentDirectional.center,
            icon: SvgPicture.asset(
              'assets/icons/ic_chevron-down.svg',
              width: 18,
            ),
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  hintText ?? "",
                  textAlign: TextAlign.left,
                  style: Ts.text.sLight.withColor(Themes.neutral3),
                )
              ],
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: (contentPadding?.horizontal ?? 25) / 2),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon,
              prefixIconConstraints: BoxConstraints(
                  maxHeight: (contentPadding?.vertical ??
                      25 + ((Ts.text.sLight.fontSize ?? 0) * 1.5))),
              suffixIconConstraints: BoxConstraints(
                  maxHeight: (contentPadding?.vertical ??
                      25 + ((Ts.text.sLight.fontSize ?? 0) * 1.5))),
              contentPadding:
                  contentPadding ?? EdgeInsets.all(Screen.isMobile ? 15 : 14.5),
              isDense: true,
              hintText: hintText,
              fillColor: Themes.primary.withAlpha((.07 * 255).toInt()),
              filled: true,
              hintStyle: Ts.text.sLight.withColor(Themes.neutral4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: Ts.text.sLight.withColor(Themes.neutral5),
            onChanged: (T? value) {
              onChanged(value);
            },
            items: [
              for (var i = 0; i < data.length; i++)
                DropdownMenuItem<T>(
                  value: data[i],
                  child: Text(labels != null ? labels![i] : '',
                      style: Ts.text.sLight.withColor(Themes.neutral5)),
                )
            ],
          ),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    this.controller,
    this.label,
    this.actionButton,
    this.hintText,
    this.onSubmit,
    this.onFocusChanged,
    this.onFilterTap,
    this.showSortBadges = false,
  });
  final TextEditingController? controller;
  final String? label;
  final Widget? actionButton;
  final String? hintText;
  final Function(String value)? onSubmit;
  final Function(bool value)? onFocusChanged;
  final VoidCallback? onFilterTap;
  final bool showSortBadges;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _focusNode = FocusNode();
  @override
  void initState() {
    _focusNode.addListener(() {
      widget.onFocusChanged?.call(_focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Themes.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0662616E)
                .withAlpha((0.05 * 255).toInt()), // Soft shadow color
            spreadRadius: 2.0, // Spread radius
            blurRadius: 6.0, // Blur radius
            offset: const Offset(0, 3), // Offset in the x and y direction
          ),
        ],
      ),
      child: TextFormField(
        maxLines: 1,
        focusNode: _focusNode,
        onTapOutside: (event) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        controller: widget.controller,
        onFieldSubmitted: widget.onSubmit,
        textInputAction: TextInputAction.search,
        style: Ts.text.mRegular.withColor(Themes.neutral5),
        decoration: InputDecoration(
          prefixIcon: _focusNode.hasFocus
              ? null
              : Clickable(
                  onTap: () {
                    widget.onSubmit?.call(widget.controller?.text ?? '');
                  },
                  child: SizedBox(
                    width: 20,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/ic_search.svg',
                      ),
                    ),
                  ),
                ),
          suffixIcon: Clickable(
            onTap: widget.onFilterTap,
            child: SizedBox(
              width: 30,
              child: Center(
                child: widget.actionButton ??
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Themes.blue1,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/ic_sort.svg',
                            width: 15,
                          ),
                        ),
                        if (widget.showSortBadges)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xff3EC927),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                      ],
                    ),
              ),
            ),
          ),
          counterText: '',
          contentPadding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 15,
              left: _focusNode.hasFocus ? 20 : 15),
          isDense: true,
          hintText: widget.hintText ?? 'Search',
          fillColor: Themes.white,
          filled: true,
          hintStyle: Ts.text.mRegular.withColor(Themes.neutral3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 0.25, color: Themes.neutral1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 0.25, color: Themes.neutral1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 0.25, color: Themes.primary2)),
        ),
      ),
    );
  }
}

class IntTextInputFormatter extends TextInputFormatter {
  IntTextInputFormatter({required this.decimalRange})
      : assert(decimalRange >= 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;

    String value = newValue.text;
    final deFormat = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalRange,
    );
    String nValue = '';
    if (value.contains(".") || value.contains(",")) {
      nValue = deFormat.format(
          (int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), "")) ??
              0)); // / 100);
    } else {
      double val = (double.tryParse(value) ?? 0); // / 100;
      nValue = deFormat.format(val);
    }
    newSelection =
        TextSelection.fromPosition(TextPosition(offset: nValue.length));

    return TextEditingValue(
      text: nValue,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange >= 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;

    String value = newValue.text;
    // final deFormat = NumberFormat.currency(
    //   locale: 'id',
    //   symbol: '',
    //   decimalDigits: decimalRange,
    // );
    String nValue = value;
    // String nValue = '';
    // if (value.contains(".") || value.contains(",")) {
    //   nValue = deFormat.format((double.tryParse(value) ?? 0)); // / 100);
    // } else {
    // double val = (double.tryParse(value) ?? 0); // / 100;
    // nValue = deFormat.format(val);
    // }
    newSelection =
        TextSelection.fromPosition(TextPosition(offset: nValue.length));

    return TextEditingValue(
      text: nValue,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

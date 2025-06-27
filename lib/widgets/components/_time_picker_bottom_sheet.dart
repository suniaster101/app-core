// 🐦 Flutter imports:
// 📦 Package imports:

import 'package:appcore/core.dart';
import 'package:appcore/widgets/willpop.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class TimePickerBottomSheet extends StatefulWidget {
  const TimePickerBottomSheet({
    super.key,
    this.initialValue,
    this.minValue,
  });
  final TimeOfDay? initialValue;
  final TimeOfDay? minValue;

  @override
  State<TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  late final _hourController = TextEditingController(
      text:
          "${(widget.minValue ?? widget.initialValue ?? TimeOfDay.now()).hour}");
  late final _minuteController = TextEditingController(
      text:
          "${(widget.minValue ?? widget.initialValue ?? TimeOfDay.now()).minute}");
  bool _hasError = false;
  bool _minimumError = false;
  final List<bool> _errors = [false, false];
  _validate() {
    final hour = _hourController.text.trim();
    final minute = _minuteController.text.trim();
    _errors[0] = hour.isEmpty || ((int.tryParse(hour) ?? 0) > 24);
    _errors[1] = minute.isEmpty || ((int.tryParse(minute) ?? 0) > 59);
    if (_errors[0] || _errors[1]) {
      setState(() => _hasError = !(_errors[0] && _errors[1]));
    } else {
      int iHour = int.parse(hour);
      int iMinute = int.parse(minute);
      if (widget.minValue != null) {
        _minimumError = (iHour < widget.minValue!.hour ||
            (iHour == widget.minValue!.hour &&
                iMinute < widget.minValue!.minute));
        setState(() {});
      }
      if (!_minimumError) {
        App.back(result: TimeOfDay(hour: iHour, minute: iMinute));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPop(
      onWillPop: (canPop) async {
        if (canPop) {
          App.back();
        }
        return canPop;
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: double.maxFinite,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: ShapeDecoration(
            color: Themes.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Container(
                width: 50,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Themes.neutral2,
                ),
              ),
            ),
            const Height(20),
            Text("Select time",
                style: Ts.text.sRegular.withColor(Themes.neutral5)),
            const Height(10),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _hourController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                  maxLength: 2,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    counterText: "",
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: _errors[0]
                        ? Themes.red.withAlpha((.2 * 255).toInt())
                        : Themes.primary.withAlpha((.1 * 255).toInt()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 40,
                  alignment: Alignment.center,
                  child: const Text(
                    ":",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    child: TextFormField(
                  controller: _minuteController,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    counterText: "",
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: _errors[1]
                        ? Themes.red.withAlpha((.2 * 255).toInt())
                        : Themes.primary.withAlpha((.1 * 255).toInt()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ))
              ],
            ),
            const Height(5),
            _hasError
                ? Text(
                    "Enter a valid time",
                    style: Ts.text.sLight
                        .copyWith(fontSize: 12, color: Themes.red),
                  )
                : Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Hour",
                        style: Ts.text.sLight.copyWith(fontSize: 12),
                      )),
                      const Width(40),
                      Expanded(
                          child: Text(
                        "Minute",
                        style: Ts.text.sLight.copyWith(fontSize: 12),
                      ))
                    ],
                  ),
            if (_minimumError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "Minimum value at ${widget.minValue?.hour.toString().padLeft(2)}:${widget.minValue?.minute.toString().padLeft(2)}",
                  style:
                      Ts.text.sLight.copyWith(fontSize: 12, color: Themes.red),
                ),
              ),
            const Height(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Clickable(
                  onTap: () {
                    App.back();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("Cancel",
                        style: Ts.text.mRegular.withColor(Themes.grey)),
                  ),
                ),
                const Width(20),
                Clickable(
                  onTap: _validate,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("OK",
                        style: Ts.text.mRegular.withColor(Themes.grey)),
                  ),
                ),
              ],
            ),
            const Height(20),
          ]),
        ),
      ]),
    );
  }
}

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({
    super.key,
    this.currentValue,
    this.isMultiple = true,
  });
  final List<DateTime?>? currentValue;
  final bool isMultiple;

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late List<DateTime?> dates = widget.currentValue ?? [];
  bool _hasError = false;
  DateTime? date;

  _validate() {
    _hasError = widget.isMultiple ? dates.isEmpty : date == null;
    if (_hasError) {
      setState(() {});
    } else {
      App.back(result: widget.isMultiple ? dates : date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPop(
      onWillPop: (canPop) async {
        if (canPop) {
          App.back();
        }
        return canPop;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: ShapeDecoration(
              color: Themes.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Themes.neutral2,
                  ),
                ),
              ),
              const Height(20),
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: widget.isMultiple
                      ? CalendarDatePicker2Type.range
                      : CalendarDatePicker2Type.single,
                  selectedRangeHighlightColor:
                      Themes.primary.withAlpha((.1 * 255).toInt()),
                  selectedDayHighlightColor: Themes.primary,
                ),
                value: dates,
                onValueChanged: (value) {
                  if (widget.isMultiple) {
                    dates = value;
                  } else {
                    date = value.first;
                  }
                },
              ),
              if (_hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    "Enter a valid time",
                    style: Ts.text.sLight
                        .copyWith(fontSize: 12, color: Themes.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Clickable(
                      onTap: () {
                        App.back();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Cancel",
                            style: Ts.text.mRegular.withColor(Themes.grey)),
                      ),
                    ),
                    const Width(20),
                    Clickable(
                      onTap: _validate,
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("OK",
                            style: Ts.text.mRegular.withColor(Themes.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

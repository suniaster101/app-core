import 'dart:io';

import 'package:appcore/external.dart';
import 'package:appcore/services/_session_service.dart';
import 'package:appcore/themes/themes.dart';
import 'package:appcore/utils/utils.dart';
import 'package:appcore/widgets/components/_time_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class HarmoniCore extends StatelessWidget {
  const HarmoniCore({super.key, this.home, this.routerConfig});
  final Widget? home;
  final RouterConfig<Object>? routerConfig;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: App.notifier,
      builder: (context, value, child) {
        Screen.init(context);
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Harmoni PoS',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            builder: (context, child) {
              bool isMobile = MediaQuery.of(context).size.shortestSide <= 450;
              return ResponsiveBreakpoints.builder(
                child: MediaQuery(
                  // key: appNavigatorKey,
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      Session.i.scaleFactor * (isMobile ? 1 : 1.1),
                    ),
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(
                      start: 1921, end: double.infinity, name: '4K'),
                ],
              );
            },
            routerConfig: routerConfig,
          ),
        );
      },
    );
  }
}

class App {
  static final ValueNotifier<bool> notifier = ValueNotifier(false);
  static forceUpdate() {
    notifier.value = !notifier.value;
  }

  static String normalizePhoneNumber(String input) {
    String cleaned = input.trim().replaceAll(RegExp(r'[^\d+]'), '');

    // Jika diawali dengan 00 (misal 0044), ubah ke + (misal +44)
    if (cleaned.startsWith('00')) {
      cleaned = '+${cleaned.substring(2)}';
    }

    // Jika sudah mulai dengan +, tetap
    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    // Jika tidak ada kode negara dan dimulai dengan 0, anggap Indonesia
    if (cleaned.startsWith('0')) {
      return '+62${cleaned.substring(1)}';
    }

    // Jika hanya angka tanpa 0 atau +, anggap Indonesia
    return '+62$cleaned';
  }

  static void pop({dynamic result}) {
    if (appNavigatorKey.currentContext != null) {
      GoRouter.of(appNavigatorKey.currentContext!).pop(result);
    }
  }

  static void back({dynamic result}) {
    if (appNavigatorKey.currentContext != null) {
      GoRouter.of(appNavigatorKey.currentContext!).pop(result);
    }
  }

  static Future<void> dialog(Widget dialog) async {
    if (appNavigatorKey.currentContext != null) {
      return showDialog<void>(
        context: appNavigatorKey.currentContext!,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  static Future<dynamic> bottomSheet(Widget dialog) async {
    if (appNavigatorKey.currentContext != null) {
      FocusScope.of(appNavigatorKey.currentContext!).unfocus();
      if (!ResponsiveBreakpoints.of(appNavigatorKey.currentContext!)
          .smallerThan(TABLET)) {
        return showDialog<void>(
          context: appNavigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: dialog,
            );
          },
        );
      }
      return showModalBottomSheet<dynamic>(
        context: appNavigatorKey.currentContext!,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: dialog,
          );
        },
      );
    }
  }

  static void showErrorToast({required String title, String? description}) {
    toastification.show(
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      type: ToastificationType.error,
      showProgressBar: false,
      backgroundColor: Themes.red,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void showSuccessToast({required String title, String? description}) {
    toastification.show(
      title: Text(title),
      description: description != null ? Text(description) : null,
      type: ToastificationType.success,
      showProgressBar: false,
      backgroundColor: Themes.primary,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static Future<TimeOfDay?> showTimePicker(
      {TimeOfDay? initialValue, TimeOfDay? minValue}) async {
    return await bottomSheet(TimePickerBottomSheet(
      initialValue: initialValue,
      minValue: minValue,
    ));
  }

  static Future<List<DateTime?>?> showRangeDatePicker(
      {List<DateTime?>? currentValue}) async {
    return await bottomSheet(DatePickerBottomSheet(
      currentValue: currentValue,
    ));
  }

  static Future<DateTime?> showDatePicker(
      {List<DateTime?>? currentValue}) async {
    return await bottomSheet(DatePickerBottomSheet(
      currentValue: currentValue,
      isMultiple: false,
    ));
  }

  static Future<File?> imagePicker({required BuildContext context}) async {
    //make user select image from gallery or camera
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(
                      context,
                      await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                          maxHeight: 1000,
                          maxWidth: 1000));
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(
                      context,
                      await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxHeight: 1000,
                          maxWidth: 1000));
                },
              ),
            ],
          ),
        );
      },
    );
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}

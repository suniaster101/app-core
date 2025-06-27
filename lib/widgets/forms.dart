import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

class FormControllers extends InheritedWidget {
  final String hash;

  const FormControllers({
    super.key,
    required this.hash,
    required super.child,
  });

  static FormControllers? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormControllers>();
  }

  static FormControllers of(BuildContext context) {
    final FormControllers? result = maybeOf(context);
    assert(result != null, 'No Forms found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FormControllers oldWidget) {
    return hash != oldWidget.hash;
  }
}

extension FormExtension on BuildContext {
  TextEditingController controller(String name,
      {String? text, bool ignore = false, bool isFile = false}) {
    return Forms.controller(this, name,
        text: text, ignore: ignore, isFile: isFile);
  }
}

class Forms extends StatefulWidget {
  const Forms({super.key, this.tag, required this.child});
  final String? tag;
  final Widget Function(BuildContext context) child;

  static final Map<String, Map<String, TextEditingController>> _controllers =
      {};
  static final Map<String, Map<String, String>> _ignorance = {};
  static final Map<String, GlobalKey<FormState>> _formkeys = {};
  static final Map<String, Map<String, String>> _isFiles = {};

  static GlobalKey<FormState> registerKey(
      {required String hash, GlobalKey<FormState>? key}) {
    _formkeys[hash] ??= GlobalKey<FormState>();
    return _formkeys[hash]!;
  }

  static TextEditingController controller(BuildContext context, String name,
      {String? text, bool ignore = false, bool isFile = false}) {
    final hash = FormControllers.of(context).hash;
    _controllers[hash] ??= {};
    _controllers[hash]?[name] ??= TextEditingController(text: text);
    if (ignore) {
      _ignorance[hash] ??= {};
      _ignorance[hash]?[name] = name;
    }
    if (isFile) {
      _isFiles[hash] ??= {};
      _isFiles[hash]?[name] = name;
    }
    return _controllers[FormControllers.of(context).hash]![name]!;
  }

  static void clear(BuildContext context) {
    final form = _controllers[FormControllers.of(context).hash] ?? {};
    for (var key in form.keys) {
      form[key]?.clear();
    }
  }

  static bool validate(BuildContext context) {
    return _formkeys[FormControllers.of(context).hash]
            ?.currentState
            ?.validate() ??
        false;
  }

  static BuildContext? getContext({required String tag}) {
    return _formkeys[tag]?.currentContext;
  }

  static bool validateWith({required String tag}) {
    return _formkeys[tag]?.currentState?.validate() ?? false;
  }

  static Future<String?> getFileFrom(
      {required String field, required String path}) async {
    try {
      return await Isolate.run(() async {
        final file = File(path.trim());
        var byteData = file.readAsBytesSync();
        String base64Image = base64Encode(byteData);
        String fileType = file.path.split('.').last;
        String base64Encoded = 'data:image/$fileType;base64,$base64Image';
        return base64Encoded;
      });
    } catch (e) {
      return null;
    }
  }

  static String? required(String value) {
    if (value.trim().isEmpty) {
      return "Required";
    }
    return null;
  }

  static Future<Map<String, dynamic>> toFormWith(
      {required String tag,
      Map<String, dynamic Function(String value)>? formaters,
      bool isNested = false,
      bool ignoreEmpty = false}) async {
    Map<String, dynamic> result = {};
    final hash = tag;
    final ignores = _ignorance[hash]?.keys.toList();
    final isFiles = _isFiles[hash]?.keys.toList();
    for (var key in (_controllers[hash] ?? {}).keys) {
      final value = _controllers[hash]?[key];
      if (!(ignores?.contains(key) ?? false)) {
        if (!(ignoreEmpty && (value?.text.trim().isEmpty ?? false))) {
          if (!(isFiles?.contains(key) ?? false)) {
            if (formaters?[key] != null) {
              result[key] = formaters![key]!.call(value!.text.trim());
            } else {
              result[key] = (value?.text.trim().isEmpty ?? false)
                  ? null
                  : value!.text.trim();
            }
          } else {
            try {
              if (value!.text.trim().isNotEmpty) {
                // var byteData = File(value.text.trim()).readAsBytesSync();
                // result[key] = MultipartFile.fromBytes(key, byteData);
              }
            } catch (_) {}
          }
        }
      }
    }

    if (isNested) {
      Map<String, dynamic> convertedMap = {};

      for (var key in result.keys) {
        RegExp regex = RegExp(r"(\w+)(?:\[(\d+)\])?\[(\w+)\]");
        Match? match = regex.firstMatch(key);
        try {
          if (match != null) {
            String? firstPart = match.group(1);
            String? secondPart = match.group(2);
            String? thirdPart = match.group(3);

            if (thirdPart != null) {
              final idx = int.tryParse(secondPart ?? '');
              if (idx == null) {
                convertedMap[firstPart ?? ''] ??= {};
                convertedMap[firstPart ?? ''][secondPart ?? ''][thirdPart] =
                    result[key];
              } else {
                convertedMap[firstPart ?? ''] ??= [];
                if (idx < (convertedMap[firstPart ?? ''] as List).length) {
                  convertedMap[firstPart ?? ''][idx][thirdPart] = result[key];
                } else {
                  convertedMap[firstPart ?? ''].add({thirdPart: result[key]});
                }
              }
            } else if (secondPart != null) {
              convertedMap[firstPart ?? ''] = result[key];
            } else {
              convertedMap[key] = result[key];
            }
          } else {
            convertedMap[key] = result[key];
          }
        } catch (_) {}
      }
      return convertedMap;
    }

    return result;
  }

  static Future<Map<String, dynamic>> toForm(BuildContext context,
      {Map<String, dynamic Function(String value)>? formaters,
      bool isNested = false,
      bool ignoreEmpty = false}) async {
    final hash = FormControllers.of(context).hash;
    return await toFormWith(
        tag: hash,
        formaters: formaters,
        ignoreEmpty: ignoreEmpty,
        isNested: isNested);
  }

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String _hash = "";
  GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    _hash = widget.tag ?? hashCode.toString();
    _formKey = Forms.registerKey(hash: _hash);
    super.initState();
  }

  @override
  void dispose() {
    Forms._formkeys.remove(_hash);
    Forms._controllers.remove(_hash);
    Forms._ignorance.remove(_hash);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormControllers(
      hash: _hash,
      child: Form(
        key: _formKey,
        child: Builder(
          builder: widget.child,
        ),
      ),
    );
  }
}

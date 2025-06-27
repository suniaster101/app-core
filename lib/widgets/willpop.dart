import 'package:appcore/utils/utils.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WillPop extends StatefulWidget {
  const WillPop({
    super.key,
    required this.child,
    this.onWillPop,
  });
  final Future<bool> Function(bool canPop)? onWillPop;
  final Widget child;

  static Map<String, FocusNode?> level = {"main": null};

  @override
  State<WillPop> createState() => _WillPopState();
}

class _WillPopState extends State<WillPop> {
  late String myHash = hashCode.toString();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.onWillPop != null) {
      WillPop.level[myHash] = _focusNode;
      BackButtonInterceptor.add(myInterceptor,
          name: myHash, zIndex: WillPop.level.length);
    }
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    Log.i("stopDefaultButtonEvent $stopDefaultButtonEvent");
    if (widget.onWillPop != null) {
      if (stopDefaultButtonEvent) return false;
      final canPop = await widget.onWillPop!.call(true);
      if (canPop) {
        WillPop.level.remove(myHash);
      }

      return canPop;
    }
    return false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.onWillPop != null) {
      WillPop.level.remove(myHash);
      BackButtonInterceptor.removeByName(myHash);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          if (WillPop.level.isNotEmpty &&
              WillPop.level.values.last.hashCode == _focusNode.hashCode) {
            if (widget.onWillPop != null) {
              await widget.onWillPop!.call(false).then(
                (value) async {
                  if (value) {
                    if (context.mounted) {
                      final canPop = await Navigator.of(context).maybePop();
                      if (canPop) {
                        WillPop.level.remove(myHash);
                      }
                    }
                  }
                },
              );
            }
          }
        }
      },
      child: widget.child,
    );
  }
}

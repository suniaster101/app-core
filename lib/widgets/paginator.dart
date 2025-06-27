import 'dart:math' as math show sin, pi;

import 'package:flutter/material.dart';

class PaginationController<T> {
  List<T> get value => _value;
  List<T> _value;
  PaginationController() : _value = [];
  final List<VoidCallback> _listeners = [];

  set value(List<T> newValue) {
    _value = newValue;
    _notifyListeners();
  }

  void add(T item) {
    value.add(item);
    _notifyListeners();
  }

  void addAll(List<T> item) {
    value.addAll(item);
    _notifyListeners();
  }

  void replaceAll(List<T> item) {
    value.clear();
    value.addAll(item);
    _notifyListeners();
  }

  void removeAt(int index) {
    value.removeAt(index);
    _notifyListeners();
  }

  void clear() {
    value.clear();
    // _notifyListeners();
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void addListener(VoidCallback fn) {
    _listeners.add(fn);
  }

  void removeListener(VoidCallback fn) {
    _listeners.remove(fn);
    if (_listeners.isEmpty) {
      _value.clear();
    }
  }
}

enum LoadingState { loading, idle }

class PagedList<T> extends StatefulWidget {
  final PaginationController<T> controller;

  final Future<List<T>> Function(int page, int pageSize) source;
  final int scrollOffset;
  final Widget? Function(BuildContext, T, int)? itemBuilder;
  final bool shrinkWrap;
  final int pageSize;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool _isSeparated;
  final Widget? emptyState;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, T, int)? separatorBuilder;

  @override
  State<PagedList<T>> createState() => _PagedListState<T>();

  const PagedList.builder({
    super.key,
    required this.controller,
    required this.source,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.pageSize = 15,
    this.physics,
    this.padding,
    this.emptyState,
    this.scrollOffset = 100,
    required this.itemBuilder,
  })  : separatorBuilder = null,
        _isSeparated = false;

  const PagedList.separated({
    super.key,
    required this.controller,
    required this.source,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.pageSize = 15,
    this.physics,
    this.padding,
    this.emptyState,
    this.scrollOffset = 100,
    required this.separatorBuilder,
    required this.itemBuilder,
  }) : _isSeparated = true;
}

class _PagedListState<T> extends State<PagedList<T>> {
  int _currentPage = 1;

  LoadingState loadingState = LoadingState.idle;
  bool isLast = false;

  @override
  void initState() {
    widget.controller.addListener(_onChanged);

    if (widget.controller.value.isEmpty) {
      freshLoad();
    }
    super.initState();
  }

  Future<void> freshLoad() async {
    isLast = false;
    _currentPage = 0;
    widget.controller.clear();
    _loadMore();
  }

  void _loadMore() {
    if (isLast) return;
    if (loadingState == LoadingState.idle) {
      _currentPage++;
      setState(() {
        loadingState = LoadingState.loading;
      });
      widget.source.call(_currentPage, widget.pageSize).then((value) {
        loadingState = LoadingState.idle;
        if (value.length < widget.pageSize) {
          isLast = true;
        }
        widget.controller.addAll(value);
      });
    }
  }

  _onChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: RefreshIndicator(
        onRefresh: () async {
          await freshLoad();
        },
        child: widget.controller.value.isEmpty &&
                loadingState != LoadingState.loading
            ? widget.emptyState ?? const SizedBox()
            : widget._isSeparated
                ? ListView.separated(
                    itemCount: widget.controller.value.length,
                    physics: widget.physics,
                    padding: widget.padding,
                    shrinkWrap: widget.shrinkWrap,
                    scrollDirection: widget.scrollDirection,
                    itemBuilder: (context, index) {
                      return widget.itemBuilder!.call(
                        context,
                        widget.controller.value[index],
                        index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return widget.separatorBuilder!.call(
                        context,
                        widget.controller.value[index],
                        index,
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: widget.controller.value.length,
                    physics: widget.physics,
                    padding: widget.padding,
                    shrinkWrap: widget.shrinkWrap,
                    scrollDirection: widget.scrollDirection,
                    itemBuilder: (context, index) {
                      return widget.itemBuilder!.call(
                        context,
                        widget.controller.value[index],
                        index,
                      );
                    },
                  ),
      ),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (widget.scrollDirection == notification.metrics.axis) {
      if (notification is ScrollUpdateNotification) {
        if (notification.metrics.maxScrollExtent >
                notification.metrics.pixels &&
            notification.metrics.maxScrollExtent -
                    notification.metrics.pixels <=
                widget.scrollOffset) {
          _loadMore();
        }
        return true;
      }

      if (notification is OverscrollNotification) {
        if (notification.overscroll > 0) {
          _loadMore();
        }
        return true;
      }
    }
    return false;
  }
}

class SpinKitThreeBounce extends StatefulWidget {
  const SpinKitThreeBounce({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
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
  State<SpinKitThreeBounce> createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<SpinKitThreeBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
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
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(begin: 0.0, end: 1.0, delay: i * .2)
                  .animate(_controller),
              child: SizedBox.fromSize(
                  size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

import 'package:flutter/material.dart';
import "dart:math";

class SnappingListView extends StatefulWidget {
  final Axis scrollDirection;
  final ScrollController? controller;

  final IndexedWidgetBuilder? itemBuilder;
  final List<Widget>? children;
  final int? itemCount;

  final double itemExtent;
  final ValueChanged<int>? onItemChanged;

  final EdgeInsets padding;
  final EdgeInsets paddingListView;

  final ScrollPhysics scrollPhysics;

  SnappingListView({
    this.scrollDirection = Axis.horizontal,
    this.controller,
    required this.children,
    required this.itemExtent,
    this.onItemChanged,
    this.padding = const EdgeInsets.all(0.0),
    this.paddingListView = const EdgeInsets.all(0.0),
    required this.scrollPhysics,
  })  : assert(itemExtent > 0),
        itemCount = null,
        itemBuilder = null;

  @override
  createState() => _SnappingListViewState();
}

class _SnappingListViewState extends State<SnappingListView> {
  int _lastItem = 0;
  late double _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    final startPadding = widget.scrollDirection == Axis.horizontal
        ? widget.padding.left
        : widget.padding.top;
    final listView = widget.children != null
        ? ListView(
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            children: widget.children!,
            itemExtent: widget.itemExtent,
            physics: widget.scrollPhysics,
            padding: widget.paddingListView,
            clipBehavior: Clip.none,
          )
        : ListView.builder(
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            itemBuilder: widget.itemBuilder!,
            itemCount: widget.itemCount,
            itemExtent: widget.itemExtent,
            physics: widget.scrollPhysics,
            padding: widget.paddingListView,
          );
    return NotificationListener<ScrollNotification>(
        child: listView,
        onNotification: (notif) {
          if (notif.depth == 0 &&
              widget.onItemChanged != null &&
              notif is ScrollUpdateNotification) {
            final currItem =
                (notif.metrics.pixels - startPadding) ~/ widget.itemExtent;
            if (currItem != _lastItem) {
              widget.onItemChanged?.call(currItem);
              _lastItem = currItem;
            }
          }
          return false;
        });
  }
}

class SnappingListScrollPhysics extends ScrollPhysics {
  final double mainAxisStartPadding;
  late double? itemExtent;

  SnappingListScrollPhysics({
    ScrollPhysics? parent,
    this.mainAxisStartPadding = 0.0,
    this.itemExtent,
  }) : super(parent: parent) {
  }

  @override
  SnappingListScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappingListScrollPhysics(
      parent: buildParent(ancestor)!,
      mainAxisStartPadding: mainAxisStartPadding,
      itemExtent: itemExtent,
    );
  }

  double _getItem(ScrollMetrics position) {
    return (position.pixels - mainAxisStartPadding) / itemExtent!;
  }

  double _getPixels(ScrollMetrics position, double item) {
    return min(item * itemExtent!, position.maxScrollExtent);
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity)
      item -= 0.5;
    else if (velocity > tolerance.velocity) item += 0.5;
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

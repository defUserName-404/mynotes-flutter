import 'package:flutter/material.dart';

class AppBottomSheetContainer extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;

  const AppBottomSheetContainer(
      {super.key, required this.child, required this.backgroundColor});

  @override
  State<AppBottomSheetContainer> createState() =>
      _AppBottomSheetContainerState();
}

class _AppBottomSheetContainerState extends State<AppBottomSheetContainer> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        key: _sheet,
        initialChildSize: 0.25,
        maxChildSize: 0.5,
        minChildSize: 0.10,
        expand: true,
        snap: true,
        snapSizes: const [0.5],
        controller: _controller,
        builder: (BuildContext context, ScrollController scrollController) =>
            DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: CustomScrollView(
                    controller: scrollController,
                    slivers: [SliverToBoxAdapter(child: widget.child)])));
  }
}

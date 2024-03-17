import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../../services/cloud/cloud_note.dart';

typedef NoteCallback = void Function();

class NoteCard extends StatefulWidget {
  final CloudNote note;
  final bool isSelected;
  final NoteCallback onTap;

  const NoteCard(
      {super.key,
      required this.note,
      required this.onTap,
      required this.isSelected});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      value: widget.isSelected ? 1 : 0,
      duration: kThemeChangeDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (BuildContext context, Widget? child) => GestureDetector(
        onTap: () => widget.onTap(),
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: GFCard(
              padding: const EdgeInsets.all(2.0),
              margin: const EdgeInsets.all(8.0),
              color: _calculateColor(),
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? CustomColors.light
                          : CustomColors.dark)),
              semanticContainer: false,
              title: GFListTile(
                padding: const EdgeInsets.all(0.0),
                margin: const EdgeInsets.all(4.0),
                avatar: const Icon(
                  Icons.note,
                  color: CustomColors.onPrimary,
                ),
                title: Text(
                  widget.note.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.onPrimary),
                ),
              ),
              titlePosition: GFPosition.start,
              content: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(2.0),
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  widget.note.content,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(color: CustomColors.light),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer),
        ),
      ),
    );
  }

  Color? _calculateColor() {
    return Color.lerp(
      Color(widget.note.color),
      Colors.grey.shade900,
      _animationController.value,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/util/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const AppButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GFButton(
      text: text,
      textStyle: const TextStyle(color: CustomColors.onAccent),
      icon: icon,
      onPressed: onPressed,
      type: GFButtonType.solid,
      color: CustomColors.primary,
      size: GFSize.LARGE,
    );
  }
}

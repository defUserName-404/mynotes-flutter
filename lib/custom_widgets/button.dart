import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Icon icon;
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
      icon: icon,
      onPressed: onPressed,
      type: GFButtonType.outline2x,
      color: Theme.of(context).buttonTheme.colorScheme!.primary,
      size: GFSize.LARGE,
    );
  }
}

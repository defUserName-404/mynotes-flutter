import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autoCorrect;

  const AppTextField(
      {super.key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.hintText,
      required this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autoCorrect = true});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: theme.colorScheme.primary)),
          prefixIcon:
              _getColoredIcon(prefixIcon, Theme.of(context).iconTheme.color),
          suffixIcon:
              _getColoredIcon(suffixIcon, Theme.of(context).iconTheme.color)),
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autoCorrect,
    );
  }

  Widget? _getColoredIcon(Widget? icon, Color? color) {
    if (icon == null) return null;
    return IconTheme(
      data: IconThemeData(color: color),
      child: icon,
    );
  }
}

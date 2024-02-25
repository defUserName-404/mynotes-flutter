import 'package:flutter/material.dart';
import 'package:mynotes/util/constants/colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color borderColor;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autoCorrect;
  final int? maxLines;
  final bool expands;
  final Function? onTap;

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
      this.expands = false,
      this.maxLines = 1,
      this.autoCorrect = true,
      this.borderColor = CustomColors.primary,
      this.focusNode,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.top,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: CustomColors.primary),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: borderColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: borderColor, width: 3)),
          prefixIcon: _getColoredIcon(prefixIcon),
          suffixIcon: _getColoredIcon(suffixIcon),
        ),
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autoCorrect,
        expands: expands,
        maxLines: maxLines,
        onTap: onTap != null ? onTap!() : null);
  }

  Widget? _getColoredIcon(Widget? icon) {
    if (icon == null) return null;
    return IconTheme(
      data: const IconThemeData(color: CustomColors.primary),
      child: icon,
    );
  }
}

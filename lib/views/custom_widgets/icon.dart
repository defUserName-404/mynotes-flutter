import 'package:flutter/material.dart';
import 'package:mynotes/util/constants/colors.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;

  const AppIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: CustomColors.primary,
    );
  }
}

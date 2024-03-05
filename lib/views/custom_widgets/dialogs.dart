import 'package:flutter/material.dart';

import 'button.dart';

class AppDialog {
  AppDialog._();

  static Future<bool> showConfirmationDialog(
      {required BuildContext buildContext,
      required String title,
      required String content,
      required IconData confirmIcon,
      required IconData cancelIcon}) async {
    return await showDialog(
        context: buildContext,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppButton(
                        text: 'Confirm',
                        icon: Icon(confirmIcon),
                        onPressed: () => Navigator.of(context).pop(true)),
                    AppButton(
                        text: 'Cancel',
                        icon: Icon(cancelIcon),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ],
                )
              ],
            )).then((value) => value ?? false);
  }

  static Future<void> showErrorDialog(
      {required BuildContext context,
      required String title,
      required String content}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          AppButton(
              text: 'Ok',
              icon: const Icon(Icons.check_circle),
              onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

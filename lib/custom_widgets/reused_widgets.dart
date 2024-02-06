import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynotes/util/constants/colors.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: CustomColors.accent,
      textColor: CustomColors.onAccent,
      fontSize: 16.0);
}

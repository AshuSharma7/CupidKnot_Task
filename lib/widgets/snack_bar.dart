import 'package:cupidknot/constants.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

showErrorSnackBar(context, String message) {
  return showTopSnackBar(
    context,
    CustomSnackBar.error(
      // backgroundColor: Colors.black,
      textStyle: TextStyle(color: Colors.white, fontSize: 18.0),
      message: message,
    ),
  );
}

showSuccessSnackBar(context, String message) {
  return showTopSnackBar(
    context,
    CustomSnackBar.success(
      message: message,
    ),
  );
}

showWarningSnack(context, String message) {
  return showTopSnackBar(
    context,
    CustomSnackBar.info(
      backgroundColor: primaryGradient[0],
      message: message,
    ),
  );
}

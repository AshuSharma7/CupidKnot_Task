import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loader({Color color = Colors.white}) {
  return SpinKitThreeBounce(
    color: color,
  );
}

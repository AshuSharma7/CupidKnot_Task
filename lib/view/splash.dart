import 'package:cupidknot/constants.dart';
import 'package:cupidknot/view_models/auth_model.dart';
import 'package:cupidknot/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    final auth = Provider.of<AuthModel>(context, listen: false);
    auth.checkCurrentUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Cupid Knot",
            style: TextStyle(
                fontSize: 35.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20.0,
          ),
          loader()
        ],
      ),
    ));
  }
}

import 'package:cupidknot/view/login.dart';
import 'package:cupidknot/view/profile.dart';
import 'package:cupidknot/view/splash.dart';
import 'package:cupidknot/view/users.dart';
import 'package:cupidknot/view_models/auth_model.dart';
import 'package:cupidknot/view_models/user_list_view_model.dart';
import 'package:cupidknot/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (_) => AuthModel()),
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<UserListViewModel>(
            create: (_) => UserListViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Montserrat"),
        home: Splash(),
      ),
    );
  }
}

import 'package:cupidknot/constants.dart';
import 'package:cupidknot/view/users.dart';
import 'package:cupidknot/utils/getDimen.dart';
import 'package:cupidknot/view_models/auth_model.dart';
import 'package:cupidknot/widgets/loader.dart';
import 'package:cupidknot/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  // Controller for text fields
  TextEditingController mail = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();

  String? gender;
  String? dob = "Select DOB";

  late AnimationController controller;
  late AnimationController controller2;
  late Animation<Offset> offset;
  late Animation<Offset> offset2;
  late Animation<Offset> offset3;
  late Animation<double> scale;
  late Animation<double> opacity2;
  late Animation<double> opacity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    offset = Tween<Offset>(end: Offset(0.0, 0.0), begin: Offset(0.0, 1.0))
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    offset3 = Tween<Offset>(end: Offset(0.0, 0.0), begin: Offset(0.0, 1.0))
        .animate(
            CurvedAnimation(parent: controller2, curve: Curves.easeInCubic));
    offset2 = Tween<Offset>(end: Offset(0.0, -0.08), begin: Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    scale = Tween<double>(end: 0.94, begin: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    opacity = Tween<double>(end: 0.6, begin: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    opacity2 = Tween<double>(end: 1.0, begin: 0.6).animate(
        CurvedAnimation(parent: controller2, curve: Curves.easeInCubic));
    controller2.forward();
  }

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 6570));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 6570)),
        initialDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(
      context,
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 100.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Text(
              "Cupid Knot",
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: opacity2,
              child: SlideTransition(
                position: offset3,
                child: FadeTransition(
                  opacity: opacity,
                  child: ScaleTransition(
                    scale: scale,
                    child: SlideTransition(
                      position: offset2,
                      child: Container(
                        padding: EdgeInsets.only(top: 30.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.4,
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Text(
                                "Login to continue",
                                style: TextStyle(fontSize: 25.0),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              tField(
                                  mail, "Enter Email...", Icons.email_rounded),
                              tField(pass, "Enter Password...",
                                  Icons.vpn_key_rounded,
                                  isObscure: true),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 20.0),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: primaryGradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      auth.checkUser(
                                          context, mail.text, pass.text);
                                    },
                                    child: Center(
                                        child: auth.loading
                                            ? loader()
                                            : Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              )),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: primaryGradient[0], width: 1.5)),
                                margin: EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 20.0),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      focusColor: primaryGradient[0],
                                      onTap: () {
                                        mail.clear();
                                        pass.clear();
                                        switch (controller.status) {
                                          case AnimationStatus.completed:
                                            controller.reverse();
                                            break;
                                          case AnimationStatus.dismissed:
                                            controller.forward();
                                            break;
                                          default:
                                        }
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => SignUp()));
                                      },
                                      child: Center(
                                          child: Text(
                                        "Create New Account",
                                        style: TextStyle(
                                            color: primaryGradient[0],
                                            fontSize: 20.0),
                                      )),
                                    )),
                              ),
                              SizedBox(
                                height: 30.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: offset,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 5) {
                    mail.clear();
                    pass.clear();
                    switch (controller.status) {
                      case AnimationStatus.completed:
                        controller.reverse();
                        break;
                      case AnimationStatus.dismissed:
                        controller.forward();
                        break;
                      default:
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(4, -5))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        tField(fname, "Enter Full Name...", Icons.person),
                        tField(mail, "Enter Email...", Icons.email_rounded),
                        tField(pass, "Enter Password...", Icons.vpn_key_rounded,
                            isObscure: true),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: getWidth(context) * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Colors.black26, width: 1.5)),
                                child: Center(
                                  child: DropdownButton(
                                    underline: SizedBox(),
                                    value: gender,
                                    onChanged: (String? val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                    hint: Text("Gender"),
                                    items: ["MALE", "FEMALE"]
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  _selectDate(context);
                                },
                                child: Container(
                                    height: getHeight(context) * 0.06,
                                    width: getWidth(context) * 0.4,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.black26, width: 1.5)),
                                    child: Center(child: Text(dob!))),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: primaryGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                if (fname.text.isEmpty ||
                                    mail.text.isEmpty ||
                                    pass.text.isEmpty ||
                                    gender == null ||
                                    dob == "Select DOB") {
                                  showWarningSnack(
                                      context, "All Fields are mandatory");
                                  return;
                                }
                                var names = fname.text.split(" ");
                                String first = names[0];
                                String last = names.length >= 2 ? names[1] : "";
                                if (last.isEmpty) {
                                  showWarningSnack(
                                      context, "Full name is required");
                                  return;
                                }
                                if (pass.text.length < 8) {
                                  showWarningSnack(context,
                                      "Password length must be of 8 or more");
                                  return;
                                }

                                auth.createUser(context, {
                                  "first_name": first,
                                  "last_name": last,
                                  "email": mail.text,
                                  "password": pass.text,
                                  "password_confirmation": pass.text,
                                  "birth_date": dob,
                                  "gender": gender
                                });
                              },
                              child: Center(
                                  child: auth.loading
                                      ? loader()
                                      : Text(
                                          "Create an Account",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        )),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: primaryGradient[0], width: 1.5)),
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              focusColor: primaryGradient[0],
                              onTap: () {
                                mail.clear();
                                pass.clear();
                                switch (controller.status) {
                                  case AnimationStatus.completed:
                                    controller.reverse();
                                    break;
                                  case AnimationStatus.dismissed:
                                    controller.forward();
                                    break;
                                  default:
                                }
                              },
                              child: Center(
                                  child: Text(
                                "Back to Login",
                                style: TextStyle(
                                    color: primaryGradient[0], fontSize: 20.0),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget tField(TextEditingController controller, String hint, IconData icon,
    {bool isObscure = false}) {
  return Container(
    // margin: EdgeInsets.all(10.0),
    margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black26, width: 1.5)),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10.0,
          ),
          Icon(
            icon,
            size: 19.0,
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: TextField(
              obscureText: isObscure,
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                alignLabelWithHint: true,
                // prefix:
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

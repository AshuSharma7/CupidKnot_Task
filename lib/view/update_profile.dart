import 'package:cupidknot/constants.dart';
import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/utils/getDimen.dart';
import 'package:cupidknot/view_models/auth_model.dart';
import 'package:cupidknot/view_models/user_view_model.dart';
import 'package:cupidknot/widgets/loader.dart';
import 'package:cupidknot/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class UpdateProfile extends StatefulWidget {
  final UserModel user;
  const UpdateProfile({Key? key, required this.user}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController mail = new TextEditingController();
  TextEditingController religion = new TextEditingController();
  TextEditingController fname = new TextEditingController();

  String? gender;
  String? dob = "Select DOB";

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 6570));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: DateTime.now().subtract(Duration(days: 6570)),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      });
  }

  @override
  void initState() {
    mail.text = widget.user.email;
    fname.text = widget.user.name;
    religion.text = widget.user.religion == "null" ? "" : widget.user.religion;
    gender = widget.user.gender;
    dob = widget.user.birthDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer<UserViewModel>(builder: (context, model, _) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: getWidth(context) * 0.07),
                ),
                SizedBox(
                  height: 20.0,
                ),
                tField(fname, "Enter Full Name...", Icons.person),
                tField(mail, "Enter Email...", Icons.email_rounded),
                tField(religion, "Enter Religion...", LineIcons.pray),
                Container(
                  margin:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: getWidth(context) * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border:
                                Border.all(color: Colors.black26, width: 1.5)),
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
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.black26, width: 1.5)),
                            child: Center(child: Text(dob!))),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10.0)),
                  margin:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: primaryGradient[0],
                        onTap: () {
                          if (fname.text.isEmpty ||
                              mail.text.isEmpty ||
                              gender == null ||
                              religion.text.isEmpty ||
                              dob!.isEmpty) {
                            showWarningSnack(
                                context, "All Fields are mandatory");
                            return;
                          }
                          var names = fname.text.split(" ");
                          String first = names[0];
                          String last = names.length >= 2 ? names[1] : "";
                          if (last.isEmpty) {
                            showWarningSnack(context, "Full name is required");
                            return;
                          }
                          user.updateUser(context, {
                            "first_name": first,
                            "last_name": last,
                            "email": mail.text,
                            "religion": religion.text,
                            "birth_date": dob,
                            "gender": gender,
                            "updated_at":
                                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}"
                          });
                        },
                        child: Center(
                            child: user.loading
                                ? loader()
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  )),
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ));
      }),
    );
  }
}

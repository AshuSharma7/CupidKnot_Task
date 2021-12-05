import 'package:cupidknot/constants.dart';
import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/view/login.dart';
import 'package:cupidknot/utils/getDimen.dart';
import 'package:cupidknot/view/update_profile.dart';
import 'package:cupidknot/view_models/auth_model.dart';
import 'package:cupidknot/view_models/user_view_model.dart';
import 'package:cupidknot/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String heroTag;
  final UserModel? user;
  final bool isOwnProfile;
  const Profile(
      {Key? key, required this.heroTag, this.user, required this.isOwnProfile})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: !widget.isOwnProfile
            ? []
            : [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfile(
                                    user: user.user!,
                                  )));
                    },
                    icon: Icon(
                      LineIcons.edit,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {
                      final user =
                          Provider.of<UserViewModel>(context, listen: false);
                      user.selectImage(context);
                    },
                    icon: Icon(
                      LineIcons.plusCircle,
                      color: primaryGradient[1],
                    )),
                IconButton(
                    onPressed: () {
                      final auth =
                          Provider.of<AuthModel>(context, listen: false);
                      auth.logout(context);
                    },
                    icon: Icon(
                      LineIcons.powerOff,
                      color: Colors.black,
                    ))
              ],
      ),
      body: user.uploadBool
          ? Center(
              child: loader(color: Colors.black),
            )
          : Consumer<UserViewModel>(builder: (context, model, _) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: (user.loading && widget.isOwnProfile)
                    ? loader(color: Colors.black)
                    : Column(
                        children: [
                          // SizedBox(
                          //   height: getHeight(context) * 0.08,
                          // ),
                          Container(
                            height: getHeight(context) * 0.15,
                            width: getWidth(context),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15.0,
                                      color:
                                          primaryGradient[1].withOpacity(0.5),
                                      offset: Offset(0, 5))
                                ],
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(
                                    colors: primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.isOwnProfile
                                          ? user.user!.name
                                          : widget.user!.name.toString(),
                                      style: TextStyle(
                                          fontSize: getWidth(context) * 0.065,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      widget.isOwnProfile
                                          ? user.user!.email.toString()
                                          : widget.user!.email.toString(),
                                      style: TextStyle(
                                          fontSize: getWidth(context) * 0.04,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                                Hero(
                                  tag: widget.heroTag,
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(widget
                                                    .isOwnProfile
                                                ? (user.user!.userImages
                                                        .isNotEmpty
                                                    ? user.user!.userImages[0]
                                                    : "https://i.stack.imgur.com/l60Hf.png")
                                                : (widget.user!.userImages
                                                        .isEmpty
                                                    ? "https://i.stack.imgur.com/l60Hf.png"
                                                    : widget
                                                        .user!.userImages[0]))),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    LineIcons.pray,
                                    color: primaryGradient[1],
                                    size: getWidth(context) * 0.05,
                                  ),
                                  Text(
                                    widget.isOwnProfile
                                        ? (user.user!.religion == "null"
                                            ? "Not found"
                                            : user.user!.religion.toString())
                                        : (widget.user!.religion == "null"
                                            ? "Not found"
                                            : widget.user!.religion.toString()),
                                    style: TextStyle(
                                      fontSize: getWidth(context) * 0.041,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    LineIcons.genderless,
                                    color: primaryGradient[1],
                                    size: getWidth(context) * 0.05,
                                  ),
                                  Text(
                                    widget.isOwnProfile
                                        ? user.user!.gender.toString()
                                        : widget.user!.gender.toString(),
                                    style: TextStyle(
                                      fontSize: getWidth(context) * 0.041,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    LineIcons.calendar,
                                    color: primaryGradient[1],
                                    size: getWidth(context) * 0.05,
                                  ),
                                  Text(
                                    widget.isOwnProfile
                                        ? user.user!.birthDate.toString()
                                        : widget.user!.birthDate.toString(),
                                    style: TextStyle(
                                      fontSize: getWidth(context) * 0.041,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: GridView.builder(
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: widget.isOwnProfile
                                    ? user.user!.userImages.length
                                    : widget.user!.userImages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index % 2 == 0 ? 0 : 10.0,
                                        right: index % 2 == 0 ? 10 : 0.0,
                                        bottom: 10.0,
                                        top: 10.0),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(widget
                                                    .isOwnProfile
                                                ? user.user!.userImages[index]
                                                : widget
                                                    .user!.userImages[index])),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10.0,
                                              color: Colors.black12
                                                  .withOpacity(0.04),
                                              offset: Offset(0, 3))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.white),
                                  );
                                }),
                          )
                        ],
                      ),
              );
            }),
    );
  }
}

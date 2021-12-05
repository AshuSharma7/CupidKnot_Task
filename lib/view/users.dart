import 'package:cupidknot/model/user_model.dart';
import 'package:cupidknot/view/profile.dart';
import 'package:cupidknot/utils/getDimen.dart';
import 'package:cupidknot/view_models/user_list_view_model.dart';
import 'package:cupidknot/view_models/user_view_model.dart';
import 'package:cupidknot/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final user_list = Provider.of<UserListViewModel>(context, listen: true);
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var currentPosition = _controller.position.pixels;
      if (currentPosition == maxScroll) {
        user_list.getNextList();
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Consumer<UserListViewModel>(builder: (context, model, _) {
          return user_list.error != null
              ? Center(
                  child: Text(
                    user_list.error.toString(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),
                  ),
                )
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Consumer<UserViewModel>(
                          builder: (context, currentUser, _) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser.loading
                                      ? "Hello"
                                      : "Hello, ${currentUser.user!.firstName}"
                                          .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getWidth(context) * 0.07),
                                ),
                                Container(
                                  width: getWidth(context) * 0.6,
                                  child: Text(
                                    "Here are some profiles based on your interest",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: getWidth(context) * 0.04),
                                  ),
                                ),
                              ],
                            ),
                            currentUser.loading
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile(
                                                    isOwnProfile: true,
                                                    heroTag: "profile",
                                                  )));
                                    },
                                    child: Hero(
                                      tag: "profile",
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(currentUser
                                                        .user!
                                                        .userImages
                                                        .isEmpty
                                                    ? "https://i.stack.imgur.com/l60Hf.png"
                                                    : currentUser
                                                        .user!.userImages[0])),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                  )
                          ],
                        );
                      }),
                      SizedBox(
                        height: 20.0,
                      ),
                      user_list.loading
                          ? loader(color: Colors.black)
                          : Expanded(
                              child: GridView.builder(
                                  controller: _controller,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: user_list.users.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Profile(
                                                      heroTag: "profile$index",
                                                      isOwnProfile: false,
                                                      user: user_list
                                                          .users[index],
                                                    )));
                                      },
                                      child: Hero(
                                        tag: "profile$index",
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: index % 2 == 0 ? 0 : 10.0,
                                              right: index % 2 == 0 ? 10 : 0.0,
                                              bottom: 15.0,
                                              top: 15.0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10.0,
                                                          offset: Offset(0, 4),
                                                          color: Colors.black12
                                                              .withOpacity(0.1))
                                                    ],
                                                    image: DecorationImage(
                                                        image: NetworkImage(user_list
                                                                .users[index]
                                                                .userImages
                                                                .isEmpty
                                                            ? "https://i.stack.imgur.com/l60Hf.png"
                                                            : user_list
                                                                .users[index]
                                                                .userImages[0]),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 9.0,
                                                    bottom: 9.0,
                                                    right: 9.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Color(0xFFff5e62)
                                                              .withOpacity(0.7)
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        stops: [0.4, 1],
                                                        end: Alignment
                                                            .bottomCenter)),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                user_list
                                                                    .users[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                "Hindu",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        getWidth(context) *
                                                                            0.03,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          LineIcons.heartAlt,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                      user_list.isNextLoading
                          ? loader(color: Colors.black)
                          : SizedBox()
                    ],
                  ),
                );
        }));
  }
}

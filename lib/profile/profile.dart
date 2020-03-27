import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mpmc/global/custom_toolbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double topHeight = 350;
  double _radius = 100;
  //Color(0xFFFF241332);
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    await respository.uploadProfilePic(image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Material(
      color: bgColor,
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _contactSection(),
              _aboutMeSection(),
              _notificationsContainer(),
              _topContainer(),
            ],
          )
        ],
      ),
    );
  }

  _topContainer() {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      height: topHeight + 50,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            height: topHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(_radius))),
            child: ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(_radius)),
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Image.network(
                    respository.user.photoUrl,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 0,
            child: CustomToolBar(
              titleVisible: true,
              title: "Profile",
            ),
          ),
          Positioned(
            top: topHeight - 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 0, right: 0),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Container(),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(_radius)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                //bgColor,
                                bgColor.withOpacity(0.7),
                                bgColor.withOpacity(0.5),
                                bgColor.withOpacity(0.1),
                              ])),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              respository.user.displayName,
                              style:
                                  Theme.of(context).textTheme.display2.copyWith(
                                      //color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "Developer",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                      //color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        IconButton(
                            color: bgColor.withOpacity(0.7),
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).iconTheme.color,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _notificationsContainer() {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: topHeight - 250),
        //height: topHeight + 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(_radius))),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 200.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.mail_outline,
                            size: 50,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {},
                        ),
                        Container(
                          child: Center(
                              child: Text(
                            "8",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                          )),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.purple),
                        )
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            size: 50,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {},
                        ),
                        Container(
                          child: Center(
                              child: Text(
                            "8",
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                    //color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                          )),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.pink[300]),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _aboutMeSection() {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: topHeight - 200),
        //height: topHeight + 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              height: 600,
              decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(_radius))),
              child: Padding(
                padding: const EdgeInsets.only(top: 370.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("About Me",
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      //color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "HR Services are utilized by three different categories, including the Management, the Customers and the Employees within a firm. ",
                        style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 16,
                              // color: Colors.white,
                              fontWeight: FontWeight.w300,
                            )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _contactSection() {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: topHeight - 200),
        //height: topHeight + 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              height: 850,
              decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(_radius))),
              child: Padding(
                padding: const EdgeInsets.only(top: 630.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("My Contacts",
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      //color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _contacts(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _contacts() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.person_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
                respository.userDoc.data["number"] == null
                    ? "Loading.."
                    : respository.userDoc.data["name"],
                style: Theme.of(context).textTheme.display1.copyWith(
                      fontSize: 16,
                      //color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.alternate_email,
              color: Theme.of(context).iconTheme.color,
            ),
            SizedBox(
              width: 20,
            ),
            Text(respository.user.email,
                style: Theme.of(context).textTheme.display1.copyWith(
                      fontSize: 16,
                      //color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
          ],
        ),
      ],
    );
  }
}

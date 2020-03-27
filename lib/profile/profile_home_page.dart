import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_screen.dart';
import 'package:mpmc/global/custom_toolbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileHomePage extends StatefulWidget {
  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  DocumentSnapshot userData;

  void getUserData() async {
    userData = await respository.getUserData(respository.user.uid);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.network(
              "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CustomToolBar(
                  title: respository.user.displayName,
                  titleVisible: true,
                ),
                Expanded(
                  child: _body(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: _profileInfo(),
          ),
          _profilePosts(),
          _profileActionsAndInfo(),
        ],
      ),
    );
  }

  _profileInfo() {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "Treasurer - MPMC",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          Text(
            "Founder and Mobile Developer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  _profilePosts() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _numberOfPosts();
            } else if (index == 9) {
              return _seeMorePosts();
            } else {
              return _profilePost(index);
            }
          }),
    );
  }

  _profileActionsAndInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "2041\n",
              style: TextStyle(
                fontSize: 24,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "FOLLOWING",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "3500\n",
              style: TextStyle(
                fontSize: 24,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "FOLLOWERS",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {},
            shape: StadiumBorder(),
            color: Theme.of(context).buttonColor,
            child: Text(
              "FOLLOWING",
            ),
          ),
          IconButton(
              icon: Icon(Icons.message),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          chatUser: userData,
                        )));
              })
        ],
      ),
    );
  }

  _numberOfPosts() {
    return Padding(
      padding: EdgeInsets.only(top: 45, bottom: 45, right: 10),
      child: Container(
        width: 80,
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "10",
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              Text(
                "POSTS",
                style: TextStyle(fontSize: 14, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  _profilePost(int index) {
    String profilePostImage = "";

    switch (index) {
      case 0:
        profilePostImage =
            "https://images.unsplash.com/photo-1520223297779-95bbd1ea79b7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1932&q=80";
        break;
      case 1:
        profilePostImage =
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80";
        break;
      case 2:
        profilePostImage =
            "https://images.unsplash.com/photo-1455274111113-575d080ce8cd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80";
        break;
      case 3:
        profilePostImage =
            "https://images.unsplash.com/photo-1532074205216-d0e1f4b87368?ixlib=rb-1.2.1&auto=format&fit=crop&w=681&q=80";
        break;
      case 4:
        profilePostImage =
            "https://images.unsplash.com/photo-1525879000488-bff3b1c387cf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80";
        break;
      case 5:
        profilePostImage =
            "https://images.unsplash.com/photo-1489779162738-f81aed9b0a25?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1382&q=80";
        break;
      default:
        profilePostImage =
            "https://images.unsplash.com/photo-1520223297779-95bbd1ea79b7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1932&q=80";
        break;
    }

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        width: 200,
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Image.network(
            profilePostImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _seeMorePosts() {
    return Padding(
      padding: EdgeInsets.only(top: 40, bottom: 40, left: 10),
      child: Container(
        width: 100,
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              Text(
                "See more",
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}

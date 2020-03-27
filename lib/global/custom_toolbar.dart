import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/authentication/login/login.dart';
import 'package:mpmc/prefrence/pref.dart';

class CustomToolBar extends StatefulWidget {
  final String title;
  final bool titleVisible, hasCustomIcon;
  final Function onPressed;
  final Widget customIcon;

  const CustomToolBar(
      {Key key,
      this.title,
      this.titleVisible = false,
      this.onPressed,
      this.hasCustomIcon = false,
      this.customIcon})
      : super(key: key);
  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20, top: 15, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          widget.titleVisible
              ? Text(
                  widget.title,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.display1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                )
              : Container(),
          DropdownButton<String>(
            underline: Container(color: Colors.transparent),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
              size: 30,
            ),
            // isExpanded: false,
            items: <String>['Themes', 'Settings', 'Logout'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),

            onChanged: (String value) {
              switch (value) {
                case "Logout":
                  respository.setUserOnlineFalse();
                  respository.signOut();
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                  break;
                case "Themes":
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Preference()));
                  break;
                case "Settings":
                  print("settings page");
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}

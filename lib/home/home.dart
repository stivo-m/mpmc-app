import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_lists.dart';
import 'package:mpmc/chat/screens/new_chat.dart';
import 'package:mpmc/dashboard/dashboard.dart';
import 'package:mpmc/events/event.dart';
import 'package:mpmc/money/money.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mpmc/profile/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _screens = [
    Dashboard(),
    ChatListsScreen(),
    MoneyScreen(),
    EventsScreen(),
    ProfileScreen()
  ];
  int index = 1;

  void initUser() async {
    respository.user = await respository.currentUser();
    respository.userDoc = await respository.getUserData(respository.user.uid);
    await respository.setUserOnlineStatus();
  }

  initFCM() {
    respository.messaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");

        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");

        return;
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        return;
      },
    );
  }

  getFcmToken() async {
    await respository.messaging.getToken();
  }

  @override
  void initState() {
    initUser();
    initFCM();
    getFcmToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updatePages(count) {
    setState(() {
      index = count;
    });
  }

  setUserOffline() async {
    await respository.setUserOnlineFalse();
  }

  Future<bool> _onWillPopScope() async {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Do You Want to Quit?",
      desc: "We would be sad to see you leave..",
      buttons: [
        DialogButton(
          color: Colors.blue,
          child: Text(
            "NO",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "YES",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setUserOffline();
            Navigator.of(context).pop(true);
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          backgroundColor: Theme.of(context).bottomAppBarColor,
          buttonBackgroundColor: Theme.of(context).bottomAppBarColor,
          color: Theme.of(context).bottomAppBarTheme.color,
          onTap: _updatePages,
          items: <Widget>[
            Icon(
              Icons.dashboard,
            ),
            Icon(Icons.message),
            Icon(Icons.money_off),
            Icon(Icons.event_available),
            Icon(Icons.person),
          ],
        ),
        body: SafeArea(
          child: _screens[index],
        ),
        floatingActionButton: _buildFloatingActionButtons(),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    Widget widget = Container();
    if (index == 1) {
      widget = buildChatFloatingButton();
    } else if (index == 3) {
      widget = buildAddEventFloatingButton();
    } else {
      widget = Container();
    }
    return widget;
  }

  FloatingActionButton buildChatFloatingButton() {
    return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).iconTheme.color,
        child: Icon(
          Icons.chat_bubble,
          color: Colors.white,
        ),
        heroTag: 1,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => NewChat()));
        });
  }

  FloatingActionButton buildAddEventFloatingButton() {
    return null;
  }
}

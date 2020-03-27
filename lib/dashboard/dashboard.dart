import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightFromTop = 100;
    double top = 120;
    return Material(
      color: Colors.orange,
      child: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: (heightFromTop * 3) + top),
              child: CustomHomeCards(
                icon: Icons.people_outline,
                topPadding: 450,
                onPress: () {},
                color: Colors.orange,
                title: "Meet the",
                subtitle: "Team",
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: (heightFromTop * 2) + top),
              child: CustomHomeCards(
                icon: Icons.money_off,
                topPadding: 350,
                onPress: () {},
                color: Colors.green,
                title: "Monthly Contributions",
                subtitle: "May 2019",
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: heightFromTop + top),
              child: CustomHomeCards(
                icon: Icons.event,
                topPadding: 250,
                onPress: () {},
                color: Colors.purple,
                title: "Upcoming Events",
                subtitle: "None",
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: top - 20),
              child: CustomHomeCards(
                topPadding: 150,
                icon: Icons.play_for_work,
                onPress: () {},
                color: Colors.blue,
                title: "Blog Posts",
                subtitle: "20 New",
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomHomeCards(
              icon: Icons.dashboard,
              onPress: () {},
              isTop: true,
              color: Colors.white,
              title: respository.user.displayName,
              subtitle: "Dashboard",
            ),
          ),
        ],
      )),
    );
  }
}

class CustomHomeCards extends StatelessWidget {
  final Function onPress;
  final String title, subtitle;
  final Color color;
  final double topPadding;
  final IconData icon;
  final bool isTop;

  const CustomHomeCards(
      {Key key,
      @required this.onPress,
      @required this.title,
      @required this.subtitle,
      @required this.color,
      this.topPadding = 70,
      this.icon,
      this.isTop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: isTop ? () {} : onPress,
                elevation: 10,
                color: color,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: topPadding,
                      bottom: isTop ? 50 : 100),
                  child: Column(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: isTop ? Colors.black : Colors.white),
                      ),
                      Text(subtitle,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 35,
                              color: isTop ? Colors.black : Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                      alignment:
                          isTop ? Alignment.centerRight : Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: 25,
                            top: isTop ? topPadding - 20 : topPadding),
                        child: Icon(
                          icon,
                          size: 100,
                          color: Colors.black12,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

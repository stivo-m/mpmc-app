import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mpmc/authentication/login/login.dart';

class MoneyScreen extends StatefulWidget {
  @override
  _MoneyScreenState createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  ScrollController _scrollController = ScrollController();
  double amount = 0.0;
  bool filled = false;
  DocumentSnapshot userData;

  _updateAmount(double value) {
    setState(() {
      amount += value;
    });
  }

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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Select an Amount To Pay",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You will Pay: $amount",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      amount = 0.0;
                    });
                  },
                  child: Material(
                      color: Colors.red,
                      elevation: 10,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text("Reset"),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 130,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CustomMoneyCards(
                    onPress: () => _updateAmount(50.0),
                    color: Colors.yellow[900],
                    amount: "50",
                    description: "Fifty Shilings",
                  ),
                  CustomMoneyCards(
                    onPress: () => _updateAmount(100.0),
                    color: Colors.blue,
                    amount: "100",
                    description: "One Hundred Shilings",
                  ),
                  CustomMoneyCards(
                    onPress: () => _updateAmount(500.0),
                    color: Colors.green,
                    amount: "500",
                    description: "Five Hundred Shilings",
                  ),
                  CustomMoneyCards(
                    onPress: () => _updateAmount(1000.0),
                    color: Colors.brown,
                    amount: "1,000",
                    description: "One Thousand Shilings",
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.purple),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Monthly Contributions"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Event's Contributions"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Other"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: TextFormField(
                  enabled: amount != 0.0,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Enter Purpose",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                  validator: (val) {
                    if (val.length < 2) {
                      return "Purpose cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String val) {},
                  onEditingComplete: () {
                    setState(() {
                      filled = true;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: MaterialButton(
                disabledColor: Theme.of(context).disabledColor,
                minWidth: double.infinity,
                onPressed: filled
                    ? () {
                        // print("NUMBER:  ${userData.data["number"]}");
                        // respository.payWithMpesa("Monthly Contribution", amount,
                        //     userData.data["number"]);
                      }
                    : null,
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Text("Complete Payment"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomMoneyCards extends StatelessWidget {
  final String amount, description;
  final Color color;
  final Function onPress;

  const CustomMoneyCards(
      {Key key,
      @required this.amount,
      @required this.description,
      @required this.color,
      @required this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 8),
      child: MaterialButton(
        onPressed: onPress,
        color: color,
        elevation: 10,
        child: Container(
          width: 200,
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  amount,
                  style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w100,
                      color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 40,
          left: 100,
          right: 100,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: NetworkImage(respository.user.photoUrl),
            ),
          ),
        ),
        Positioned(
          top: 370,
          right: 100,
          left: 100,
          child: Column(
            children: <Widget>[
              Text(" Name: ${respository.user.displayName}"),
              SizedBox(
                height: 20,
              ),
              Text(" Email: ${respository.user.email}"),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MaterialButton(
              child: Text("LOGOUT"),
              color: Colors.red,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              onPressed: () {
                respository.signOut().then((val) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                });
              }),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpmc/global/custom_toolbar.dart';
import 'package:mpmc/global/widgets.dart';

import 'bloc/bloc.dart';

class MoneyScreen extends StatefulWidget {
  @override
  _MoneyScreenState createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;
  AnimationController _animationController;
  String initialValue = "Select Amount";

  DocumentSnapshot userData;
  bool isTransacting = false;

  double top = 150;
  double btnPadding = 30;

  @override
  void initState() {
    _controller = ScrollController();
    _animationController = AnimationController(
      duration: Duration(microseconds: 300),
      vsync: this,
    );

    //_animationController.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: BlocProvider(
          builder: (context) => FinanceBloc(),
          child: BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  _overViewSection(),
                  _centerSection(),
                  _bottomSection(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _overViewSection() {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 5,
        color: Theme.of(context).cardColor,
        child: Container(
          height: top,
          width: double.infinity,
          decoration: BoxDecoration(
              // color: Theme.of(context).cardColor,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(100))),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0.05 * top,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomToolBar(
                      title: "Finances",
                      titleVisible: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Your Last M.C was on 20-August-2019",
                        style: Theme.of(context).textTheme.display2.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _centerSection() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
          padding:
              EdgeInsets.only(top: top + 20, left: 20, right: 20, bottom: 10),
          child: Container(
            height: 250,
            width: double.infinity,
            child: Card(
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Select an item to Pay".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: 24),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      children: <TableRow>[
                        TableRow(children: [
                          MPMCButton(
                            btnText: "Pay M.C",
                            btnColor: Colors.green,
                            isRounded: false,
                            onPressedCallback: () {},
                          ),
                          MPMCButton(
                            btnText: "Pay for Event",
                            btnColor: Colors.blue,
                            isRounded: false,
                            onPressedCallback: () {},
                          ),
                        ]),
                        TableRow(children: [
                          MPMCButton(
                            btnText: "Pay for T-Shirt",
                            btnColor: Colors.deepOrange,
                            isRounded: false,
                            onPressedCallback: () {},
                          ),
                          MPMCButton(
                            btnText: "Other",
                            btnColor: Colors.purple,
                            isRounded: false,
                            onPressedCallback: () {},
                          ),
                        ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  _bottomSection(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: (top * 3), bottom: 10),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 19.0),
          elevation: 10,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
            height: 300,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Enter Details Below".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Debts amount to : Ksh. 200 for ${200 / 50} Months",
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  underline: Container(color: Colors.transparent),
                  hint: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Text(
                          initialValue,
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  icon: Container(),
                  // isExpanded: false,
                  items: <String>['50', '100', '200', '500', "1,000"]
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),

                  onChanged: (String value) {
                    setState(() {
                      initialValue = "$value";
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                BlocListener<FinanceBloc, FinanceState>(
                    listener: (context, state) {
                      if (state is ProcessingPayments) {
                        if (state.processing) {
                          isTransacting = state.processing;
                        }
                      }
                      if (state is TransactionSuccess) {
                        if (state.success) {
                          isTransacting = false;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            content: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.verified_user,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(state.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14))
                              ],
                            ),
                          ));
                        }
                      }

                      if (state is TransactionFailed) {
                        if (state.success == false) {
                          isTransacting = false;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            content: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(state.errorMessage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14))
                              ],
                            ),
                          ));
                        }
                      }
                    },
                    child: Container()),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: isTransacting
                      ? CircularProgressIndicator()
                      : MPMCButton(
                          btnText: "Proceed",
                          btnColor: Colors.blue,
                          onPressedCallback: () {
                            if (initialValue == "Select Amount") {
                              return;
                            } else {
                              BlocProvider.of<FinanceBloc>(context).dispatch(
                                  MPESATransaction(
                                      amount: double.parse(initialValue),
                                      description: "Monthly Contribution"));
                            }
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

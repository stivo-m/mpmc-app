import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';

class Meeting extends StatefulWidget {
  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  String date, venue, agenda, discussions;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isProcessing = false;
  String validateInputs(String val) {
    String error;
    if (val.length < 1) {
      error = 'Field Cannot be Empty!';
    } else {
      error = null;
    }

    return error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text("Schedule Meeting"),
      ),
      body: BlocProvider(
        builder: (context) => EventsBloc(),
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return _buildMeetingInputForm(context, state);
          },
        ),
      ),
    );
  }

  _buildMeetingInputForm(BuildContext context, EventsState eventsState) {
    return BlocListener<EventsBloc, EventsState>(
        listener: (BuildContext context, EventsState state) {
          if (state is AddingEventState) {
            if (state.processing) {
              isProcessing = true;
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blue,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.donut_small, color: Colors.white),
                    Text(
                      "Scheduling Meeting...",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ));
            }
          }

          if (state is EventAdded) {
            if (state.success) {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.verified_user, color: Colors.white),
                    Text(
                      "Meeting Scheduled...",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ));

              isProcessing = false;

              _key.currentState.reset();
            }
          }
        },
        child: Form(
          key: _key,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20,
                right: 20,
                left: 20,
                child: Center(
                  child: Text(
                    "Set the Meeting",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(fontSize: 40, fontWeight: FontWeight.w200),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 20,
                left: 20,
                child: Center(
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Meeting's Agenda",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ))),
                    onSaved: (String val) {
                      agenda = val;
                    },
                    validator: validateInputs,
                  ),
                ),
              ),
              Positioned(
                top: 200,
                right: 20,
                left: 20,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Meeting's Veue",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ))),
                    onSaved: (String val) {
                      venue = val;
                    },
                    validator: validateInputs,
                  ),
                ),
              ),
              Positioned(
                top: 300,
                right: 20,
                left: 20,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        labelText: "Meeting's Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ))),
                    onSaved: (String val) {
                      date = val;
                    },
                    validator: validateInputs,
                  ),
                ),
              ),
              Positioned(
                top: 400,
                right: 20,
                left: 20,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Meeting's Points of Discussion",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ))),
                    onSaved: (String val) {
                      discussions = val;
                    },
                    validator: validateInputs,
                  ),
                ),
              ),
              Positioned(
                top: 500,
                right: 20,
                left: 20,
                child: Center(
                    child: MaterialButton(
                  disabledColor: Theme.of(context).highlightColor,
                  elevation: 5,
                  minWidth: double.infinity,
                  color: Theme.of(context).buttonColor,
                  onPressed: isProcessing
                      ? null
                      : () {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            BlocProvider.of<EventsBloc>(context).dispatch(
                                ScheduleMeeting(
                                    agenda: agenda,
                                    venue: venue,
                                    date: date,
                                    discussions: discussions));
                          } else {
                            setState(() {
                              isProcessing = false;
                            });
                          }
                        },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text("Request Meeting")),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 16),
                        child: Text("CHECK PLANNED MEETINGS"),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

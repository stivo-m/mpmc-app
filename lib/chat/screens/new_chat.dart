import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_screen.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Start New Chat",
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(fontSize: 25, fontWeight: FontWeight.w200)),
      ),
      body: StreamBuilder(
          stream: respository.db.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    "No Users Avalable for Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 17),
                  ),
                );
              }

              return ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  reverse: false,
                  controller: _scrollController,
                  children: snapshot.data.documents.map<Widget>((user) {
                    return user.data["uid"] == respository.user.uid
                        ? Container()
                        : ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatScreen(
                                            chatUser: user,
                                          )));
                            },
                            leading: CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person),
                            ),
                            title: Text(user.data["name"]),
                            subtitle: Text("New User"),
                          );
                  }).toList());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

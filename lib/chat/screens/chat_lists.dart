import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_screen.dart';
import 'package:mpmc/global/custom_toolbar.dart';

class ChatListsScreen extends StatefulWidget {
  @override
  _ChatListsScreenState createState() => _ChatListsScreenState();
}

class _ChatListsScreenState extends State<ChatListsScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          children: <Widget>[
            CustomToolBar(
              title: "Chats",
              titleVisible: true,
            ),
            StreamBuilder(
                stream: respository.db.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text(
                          "No Chats Available",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w100, fontSize: 17),
                        ),
                      );
                    }

                    return ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        reverse: false,
                        controller: _scrollController,
                        children: snapshot.data.documents.map<Widget>((users) {
                          return _buidChatListScreen(users);
                        }).toList());
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget _buidChatListScreen(DocumentSnapshot doc) {
    if (doc.data["uid"] == respository.user.uid) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          StreamBuilder(
            stream: respository.db
                .collection("users")
                .where("uid", isEqualTo: doc.documentID)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data.documents.length == 0) {
                  return Center(
                    child: Text("No Active Chats"),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      chatUser: doc,
                                    )));
                          },
                          contentPadding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 20),
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: 20,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      child: Hero(
                                        tag: doc.documentID,
                                        child: Image(
                                          image: NetworkImage(
                                              doc.data["photoURL"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxHeight: 12, maxWidth: 12),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: doc.data["online"]
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          title: Text(doc.data["name"]),
                          subtitle: Text("",
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                          trailing: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "12:24pm",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 55),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Container();
            },
          )
        ],
      );
    }
  }
}

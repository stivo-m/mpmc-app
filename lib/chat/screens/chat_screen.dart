import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpmc/chat/chat_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mpmc/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot chatUser;
  const ChatScreen({Key key, @required this.chatUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController;
  bool isChatEmpty = true;
  User user;

  Future uploadImage(BuildContext context) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    isChatEmpty
        ? chat.uploadFirstChatImage(image, widget.chatUser.data["uid"])
        : chat.uploadImage(image, widget.chatUser.data["uid"]);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients)
        _scrollController.animateTo(0.0,
            curve: Curves.easeInOut, duration: Duration(milliseconds: 100));
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();

    scrollToBottom();

    user = User.fromMap(respository.userDoc.data);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Hero(
            tag: widget.chatUser.documentID,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image(
                            image:
                                NetworkImage(widget.chatUser.data["photoURL"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            constraints:
                                BoxConstraints(maxHeight: 12, maxWidth: 12),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.chatUser.data["online"]
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          centerTitle: true,
        ),
        body: BlocProvider(
          builder: (context) => ChatBloc(),
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return _buildBody(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _chatLogSection(context),
        ),
        SizedBox(
          height: 15,
        ),
        BottomInputField(
          state: state,
          controller: _controller,
          pickImage: () {
            uploadImage(context);
          },
          onPressed: () {
            if (_controller.text.isEmpty || _controller.text.trim() == '') {
              return;
            }

            BlocProvider.of<ChatBloc>(context).dispatch(
              SendMessage(
                message: _controller.text,
                sender: User.fromMap(respository.userDoc.data),
                receiver: User.fromMap(widget.chatUser.data),
              ),
            );
            _scrollController.animateTo(0.0,
                curve: Curves.easeIn, duration: Duration(milliseconds: 100));

            setState(() {
              _controller.clear();
              _controller.text = "";
            });
          },
        ),
      ],
    );
  }

  Widget _chatLogSection(BuildContext contex) {
    return StreamBuilder(
        stream: respository.db
            .collection("chats")
            .document(respository.user.uid)
            .collection(widget.chatUser.data["uid"])
            .orderBy("sent_at", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              isChatEmpty = true;
              return Center(
                child: Text(
                  "No Messages. Start Chat",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 17),
                ),
              );
            }

            isChatEmpty = false;

            return ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: true,
                controller: _scrollController,
                children: snapshot.data.documents.map<Widget>((msg) {
                  bool isMine = msg.data["sender"] == respository.user.uid;
                  bool isFile = msg.data["type"] == "file";
                  return AnimatedContainer(
                    curve: Curves.easeOut,
                    duration: Duration(milliseconds: 100),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isMine
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: isMine
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: <Widget>[myMessage(msg, isMine, isFile)],
                        )
                      ],
                    ),
                  );
                }).toList());
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  myMessage(DocumentSnapshot msg, bool isMine, bool isFile) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(top: 5),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 50, minWidth: 80),
        decoration: isMine
            ? BoxDecoration(
                color: isFile ? Colors.transparent : Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              )
            : BoxDecoration(
                color: isFile ? Colors.transparent : Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
        child: Padding(
          padding: isMine
              ? EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10)
              : EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: isFile
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          msg.data["photo"],
                          fit: BoxFit.contain,
                        ),
                      )
                    : Text(
                        msg.data["message"],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        softWrap: true,
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    DateFormat("Hm").format(msg.data["sent_at"].toDate()),
                    style: TextStyle(
                        color: isFile ? Colors.black87 : Colors.white54,
                        fontStyle: FontStyle.italic,
                        fontSize: 10),
                  ),
                  isMine
                      ? Container()
                      : Icon(
                          msg.data["read"] == true
                              ? Icons.done_all
                              : Icons.done,
                          color: msg.data["read"] == true
                              ? Colors.blue
                              : Colors.grey,
                          size: 15,
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressed, pickImage;
  final bool isGroup;
  final ChatState state;

  BottomInputField(
      {Key key,
      @required this.controller,
      @required this.onPressed,
      this.pickImage,
      @required this.state,
      this.isGroup = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _onChanged() {
      controller.addListener(() {
        if (isGroup) {
          if (controller.text.hashCode == "@".hashCode) {
            print("Finally");
            return;
          } else {
            print("Not Yet @");
          }
        }
      });
    }

    return Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 8),
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white10,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  hintText: 'Your Message',
                ),
                onChanged: _onChanged(),
                controller: controller,
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.attach_file),
              iconSize: 23,
              onPressed: pickImage),
          IconButton(icon: Icon(Icons.send), iconSize: 23, onPressed: onPressed)
        ],
      ),
    );
  }
}

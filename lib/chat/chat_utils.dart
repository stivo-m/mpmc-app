import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mpmc/models/message_model.dart';
import 'package:mpmc/models/user_model.dart';
import 'package:path/path.dart';

class Chat {
  final _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadImage(File file, String recipient) async {
    String chatID = getChatId(respository.user.uid, recipient);
    //Create a reference to the location you want to upload to in firebase
    String fileName = basename(file.path);
    StorageReference reference = _storage.ref().child("chats/$fileName");
    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(file);
    // Waits till the file is uploaded then stores the download url
    String data = await (await uploadTask.onComplete).ref.getDownloadURL();
    await chat._db
        .collection("Chat")
        .document(chatID)
        .collection("messages")
        .add({
      "type": "file",
      "id": chatID,
      "sender": respository.user.uid,
      "senderName": respository.user.displayName,
      "recipient": recipient,
      "photo": data,
      "sent_at": DateTime.now(),
      "read": false,
    });
  }

  Future uploadFirstChatImage(File file, String recipient) async {
    String chatID = getChatId(respository.user.uid, recipient);
    //Create a reference to the location you want to upload to in firebase
    String fileName = basename(file.path);
    StorageReference reference = _storage.ref().child("chats/$fileName");
    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(file);
    // Waits till the file is uploaded then stores the download url
    String data = await (await uploadTask.onComplete).ref.getDownloadURL();
    var devToken = await respository.messaging.getToken();
    var chatDB = _db.collection("Chat").document(chatID);
    await chatDB.setData({
      "chatID": chatID,
      "chat_started": DateTime.now(),
      "User1": respository.user.uid,
      "User2": recipient,
    });
    await chat._db
        .collection("Chat")
        .document(chatID)
        .collection("messages")
        .add({
      "type": "file",
      "id": chatID,
      "sender": respository.user.uid,
      "senderName": respository.user.displayName,
      "recipient": recipient,
      "devToken": devToken,
      "photo": data,
      "sent_at": DateTime.now(),
      "read": false,
    });
  }

  Future startNewChat(String recipient, String message, String devToken) async {
    String chatID = getChatId(respository.user.uid, recipient);
    var chatDB = _db.collection("Chat").document(chatID);
    //get the chat collection
    print("starting");
    await chatDB.setData({
      "chatID": chatID,
      "chat_started": DateTime.now(),
      "User1": respository.user.uid,
      "User2": recipient,
    });

    //add message to the db
    await chatDB.collection("messages").add({
      "type": "message",
      "sender": respository.user.uid,
      "senderName": respository.user.displayName,
      "recipient": recipient,
      "devToken": devToken,
      "message": message,
      "sent_at": DateTime.now(),
      "read": false,
    });
  }

  Future sendMessage(String recipient, String message, String devToken) async {
    String chatID = getChatId(respository.user.uid, recipient);

    await _db.collection("Chat").document(chatID).collection("messages").add({
      "id": chatID,
      "type": "message",
      "sender": respository.user.uid,
      "senderName": respository.user.displayName,
      "recipient": recipient,
      "devToken": devToken,
      "message": message,
      "sent_at": DateTime.now(),
      "read": false,
    });
  }

  String getChatId(String sender, String recipient) {
    String chatID;
    if (sender.hashCode > recipient.hashCode) {
      chatID = sender + recipient;
    } else {
      chatID = recipient + sender;
    }

    return chatID;
  }

  bool checkIfChatIdExists(String me, String chatID) {
    bool isMine = false;

    if (chatID.contains(me)) {
      isMine = true;
    } else {
      isMine = false;
    }

    return isMine;
  }

  //send a message
  Future sendAmessage(User recipient, User sender, Message message) async {
    await _db
        .collection("chats")
        .document(sender.id)
        .collection(recipient.id)
        .add(message.toMap());

    return await _db
        .collection("chats")
        .document(recipient.id)
        .collection(sender.id)
        .add(message.toMap());
  }

  //send an image
  Future sendChatImage(
      File file, User sender, User recipient, Message message) async {
    //Create a reference to the location you want to upload to in firebase
    String fileName = basename(file.path);
    StorageReference reference = _storage.ref().child("chats/$fileName");
    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(file);
    // Waits till the file is uploaded then stores the download url
    String data = await (await uploadTask.onComplete).ref.getDownloadURL();
    message.imageFile = data;

    await _db
        .collection("chats")
        .document(sender.id)
        .collection(recipient.id)
        .add(message.toMap());

    return await _db
        .collection("chats")
        .document(recipient.id)
        .collection(sender.id)
        .add(message.toMap());
  }
}

Chat chat = Chat();

class Message {
  final String senderId, receiverId, message;
  final DateTime dateTime;
  String imageFile;

  Message({
    this.senderId,
    this.receiverId,
    this.message,
    this.dateTime,
  });

  Message.imageMessage({
    this.senderId,
    this.receiverId,
    this.message,
    this.dateTime,
    this.imageFile,
  });

  Message.fromMap(Map<String, dynamic> msg)
      : this.message = msg["message"],
        this.dateTime = msg["sent_at"],
        this.receiverId = msg["recipient"],
        this.senderId = msg["sender"];

  Map toMap() {
    Map msg = Map<String, dynamic>();

    msg["message"] = this.message;
    msg["sent_at"] = this.dateTime;
    msg["recipient"] = this.receiverId;
    msg["sender"] = this.senderId;

    return msg;
  }
}

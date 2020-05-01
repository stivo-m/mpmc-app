class User {
  final String id, name, email, photoUrl, devToken;

  User({this.id, this.name, this.email, this.photoUrl, this.devToken});

  User.fromMap(Map<String, dynamic> map)
      : this.id = map["uid"],
        this.name = map["displayName"],
        this.email = map["email"],
        this.photoUrl = map["photoUrl"],
        this.devToken = map["devToken"];

  Map toMap() {
    var map = Map<String, dynamic>();
    map["uid"] = this.id;
    map["displayName"] = this.name;
    map["email"] = this.email;
    map["photoUrl"] = this.photoUrl;
    map["devToken"] = this.devToken;
    return map;
  }
}

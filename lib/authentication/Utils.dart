import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mpmc/events/bloc/bloc.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRespository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseMessaging messaging = FirebaseMessaging();
  Firestore db = Firestore.instance;
  FirebaseUser user;
  DocumentSnapshot userDoc;

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      //final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initFCM() {
    respository.messaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");

        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");

        return;
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        return;
      },
    );
  }

  Future uploadProfilePic(File image) async {
    //Create a reference to the location you want to upload to in firebase
    String fileName = basename(image.path);
    StorageReference reference = _storage.ref().child("images/$fileName");
    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);
    // Waits till the file is uploaded then stores the download url
    String data = await (await uploadTask.onComplete).ref.getDownloadURL();
    UserUpdateInfo info = UserUpdateInfo();
    info.photoUrl = data;
    print("IMAGE: $data");
    await user.updateProfile(info);
    await user.reload();
    user = await _auth.currentUser();

    await respository.db.collection("users").document(user.uid).updateData({
      "photoURL": data,
    });
  }

  setUserOnlineStatus() async {
    await respository.db.collection("users").document(user.uid).updateData({
      "online": true,
    });
  }

  setUserOnlineFalse() async {
    await respository.db.collection("users").document(user.uid).updateData({
      "online": false,
    });
  }

  handleMpesaInitialization() {
    MpesaFlutterPlugin.setConsumerKey("jNsONUzVRfZCc0p9QZjTc7TVJfnufhwB");
    MpesaFlutterPlugin.setConsumerSecret("N2eUp4Nq9TwGl8AI");
  }

  Future updateUserPaymentDetails(info) async {
    await respository.db
        .collection("MPESA")
        .document(info["CheckoutRequestID"])
        .setData({
          "user": user.uid,
          "CheckoutRequestID": info["CheckoutRequestID"],
          "MerchantRequestID": info["MerchantRequestID"],
          "ResponseCode": info["ResponseCode"],
          "ResponseDescription": info["ResponseDescription"],
          "CustomerMessage": info["CustomerMessage"]
        })
        .catchError((e) => print(e.toString()))
        .whenComplete(() => print("Completed"));
  }

  Future payWithMpesa(String desc, double amount) async {
    String number = "254746244453"; //await userDoc.data["number"];
    dynamic transactionInitialisation;
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: number,
          partyB: "174379",
          callBackURL: Uri.parse(
              "https://mpmc-d17b7.firebaseio.com/transactions.json?auth=6QrmXOjpI9Ibh6rZ5xIjgNiymxEvKhf84Ad5nsOa"),
          accountReference: desc,
          phoneNumber: number,
          baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
          transactionDesc: desc,
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");
      await updateUserPaymentDetails(transactionInitialisation);
      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  Future addEventToList(AddEvent event) async {
    await respository.db.collection("Events").add({
      "theme": event.theme,
      "date": event.date,
      "title": event.description,
      "venue": event.venue,
      "added_by": respository.user.email,
      "last_updated": DateTime.now()
    }).catchError((onError) {
      print(onError.toString());
    }).then((onValue) {
      print(onValue.documentID);
    });
  }

  Future detleteEvent(String id) async {
    await respository.db
        .collection("Events")
        .document(id)
        .delete()
        .catchError((onError) {
      print(onError.toString());
    });
  }

  Future scheduleMeeting(
      String agenda, String venue, String date, String discussion) async {
    await respository.db.collection("Meetings").add({
      "agenda": agenda,
      "venue": venue,
      "date": date,
      "discussionPoints": discussion,
      "requestedBy": respository.user.displayName,
      "addedBy": respository.user.email
    }).catchError((onError) => print(onError.toString()));
  }

  Future signOut() async {
    //await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  userID() async {
    return await currentUser().then((u) => u.uid);
  }

  Future<DocumentSnapshot> getUserData(String id) async {
    return await db.collection("users").document(user.uid).get();
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    initFCM();

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
          user = authResult.user;
          await user.reload();
          userDoc = await getUserData(user.uid);
        })
        .then((doc) {
          handleMpesaInitialization();
        })
        .whenComplete(() => _updateLastLogin(user))
        .catchError((e) => print("LoginError from UTILS: $e"));
    return user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String password, String name, String number) async {
    initFCM();
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      user = authResult.user;
      handleMpesaInitialization();

      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      info.photoUrl = "https://static.thenounproject.com/png/538846-200.png";

      await user.updateProfile(info);
      await user.reload();
      await _saveUserData(user, name, number);
      userDoc = await getUserData(user.uid);
      user.sendEmailVerification();
    });

    return user;
  }

  Future<FirebaseUser> googleSignin() async {
    GoogleSignInAccount googleAccount;

    googleAccount = await _getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }

    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    user = await _auth.signInWithCredential(credential).then((authResult) {
      return authResult.user;
    }).whenComplete(() {});

    return user == null ? null : user;
  }

  Future<GoogleSignInAccount> _getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future _saveUserData(FirebaseUser user, String name, String number) async {
    var devToken = await respository.messaging.getToken();
    if (user != null) {
      DocumentReference data = db.document("users/" + user.uid);
      await data.setData({
        "name": name,
        "devToken": devToken,
        "photoURL": "https://static.thenounproject.com/png/538846-200.png",
        "uid": user.uid,
        "email": user.email,
        "isVerified": user.isEmailVerified,
        "number": number,
      }, merge: true);
    }
  }

  void _updateLastLogin(FirebaseUser user) async {
    var devToken = await respository.messaging.getToken();
    if (user != null) {
      await db.collection("users").document(user.uid).updateData({
        "uid": user.uid,
        "devToken": devToken,
        "last_seen": DateTime.now(),
      });
    }
  }
}

UserRespository respository = UserRespository();

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:telyportsample/Static/Error_Handling.dart';

class Database_Services{
  Error_Handling error_handling = new Error_Handling();
  Future<void> addLocationToFb(LocationData locationDto) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    await signInAnonymously();

    if(firebaseUser != null){
      CollectionReference collectionReference1 = FirebaseFirestore.instance.collection(firebaseUser.uid??'Location');
      await collectionReference1.add({
        'lat': locationDto.latitude,
        'long':locationDto.longitude,
        'time': DateTime.now(),
        'uid': firebaseUser.uid,
      }).then((value) {
        print("Added to firebase:>");
        return 'Done';
      }).catchError((onError){
        return '$onError';
      });
    }
    else{
      print("Firebase user is null user");
    }

  }
  Future<void> signInAnonymously()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    if(firebaseUser == null){
      try{
        await _auth.signInAnonymously().then((result) {
          final User user = result.user;
          print(user.uid);
        });
        return 'SignedIn';
      }on FirebaseAuthException catch(e){
        return 'Not';
      }
    }
    else{
      print("firebase user is not null");
    }
  }
  Future<void> addTextToFb(String text, BuildContext context,DocumentSnapshot documentSnapshot) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if(text!=null) {
      if (!(documentSnapshot == null)) {
        await firestore.collection('Text')
            .doc('Texter').collection(firebaseUser.uid).doc(documentSnapshot.id)
            .update({
          "time": DateTime.now(),
          "text": text,
        })
            .then((value) {
          error_handling.printSuccess("List updated!");
        });
      }
      else {
        await firestore.collection('Text').doc('Texter').collection(firebaseUser.uid).add({
          "time": DateTime.now(),
          "text": text,
        }).then((value) {
          error_handling.printSuccess("List added!");
        });
      }
    }
  }
  Future<void> deleteTextFromFb(
      DocumentSnapshot documentSnapshot) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('Text')
        .doc('Texter')
        .collection(firebaseUser.uid)
        .doc(documentSnapshot.id)
        .delete()
        .then((value) {
      error_handling.printSuccess("Listy deleted!");
    }).catchError((error) {
      error_handling.printError(
          "Something's wrong! check internet connection and try again!");
    });
  }
  Future<String> checkConnectivity(BuildContext context)async{

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'Connected';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'Connected';
      // I am connected to a wifi network.
    }
    else{
      showDialog(context: context, builder: (context){
        return AlertDialog(
          elevation: 24,
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            "No internet!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Text(
            "Please connect to a network!",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.blue[200], fontSize: 18),
              ),
            ),
          ],
        );
      });
      return 'Not Connected';
    }
  }
}
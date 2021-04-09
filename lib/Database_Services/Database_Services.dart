
import 'package:cloud_firestore/cloud_firestore.dart';
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
        await firestore.collection(firebaseUser.uid)
            .doc(documentSnapshot.id)
            .update({
          "time": DateTime.now(),
          "text": text,
        })
            .then((value) {
          error_handling.printSuccess("List updated!");
        });
      }
      else {
        await firestore.collection(firebaseUser.uid).add({
          "time": DateTime.now(),
          "text": text,
        }).then((value) {
          error_handling.printSuccess("List added!");
        });
      }
    }
  }

}
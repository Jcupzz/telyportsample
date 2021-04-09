
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class Database_Services{

  Future<void> addLocationToFb(LocationData locationDto) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await signInAnonymously();
    CollectionReference collectionReference1 = FirebaseFirestore.instance.collection(firebaseUser.uid??'Location');
    await collectionReference1.add({
      'lat': locationDto.latitude,
      'long':locationDto.longitude,
      'time': locationDto.time,
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

}
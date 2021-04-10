import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/Pages/DetailsPage.dart';
import 'package:telyportsample/Static/Loading.dart';

import 'Edit_Text.dart';

class DisplayNotesPage extends StatefulWidget {
  @override
  _DisplayNotesPageState createState() => _DisplayNotesPageState();
}

class _DisplayNotesPageState extends State<DisplayNotesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot documentSnapshot;
  final texteditingcontroller = TextEditingController();
  Database_Services database_services = new Database_Services();
  DetailsPage detailsPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database_services.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;
    return firebaseUser == null?Container(color: Colors.white,):Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('Text')
                    .doc('Texter')
                    .collection(firebaseUser.uid)
                    .orderBy('time',descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Card(
                              color: Colors.white,
                              elevation: 14,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Edit_Text(document)));
                                },
                                onLongPress: () {
                                  showDeleteDialog(document);
                                },
                                title: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document['text'],
                                        maxLines: 5,
                                        style: TextStyle(color: Colors.black,fontSize: 18),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(
                                        format_posted_time(document['time']).toString(),
                                        style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }).toList(),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(DocumentSnapshot doc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            backgroundColor: Colors.blue[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(
              "Delete",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            content: Text(
              "Do you want to delete this Note?",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                ),
              ),
              FlatButton(
                onPressed: () {
                  database_services.deleteTextFromFb(doc);
                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
                ),
              ),
            ],
          );
        });
  }
  String format_posted_time(Timestamp posted_time) {
    DateTime postedDate = posted_time.toDate(); //Converted timestamp to DateTime

    bool numericDates = true;

    final date2 = DateTime.now();

    final difference = date2.difference(postedDate);

    if (difference.inDays > 8) {
      return 'More than 8 days'; // TODO : Should change more than 8 days
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

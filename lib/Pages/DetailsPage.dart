import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telyportsample/Static/Loading.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("iDetails")
                .where('isRequested', isEqualTo: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          child: ListTile(
                            onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => Details(document)));
                             },
                            onLongPress: () {
                              //showDeleteDialog(document);
                            },
                            //subtitle: Text(document['iType']),
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Lattitude: "+
                                      document.data()['lat'],
                                      style:Theme.of(context).textTheme.headline3),
                                  Text(
                                      "Longitude: "+
                                      document.data()['long'],
                                      style:Theme.of(context).textTheme.headline5),
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
    );
  }
}

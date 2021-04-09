import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/Pages/Edit_Text.dart';

class AddNotesPage extends StatefulWidget {
  @override
  _AddNotesPageState createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {

  Database_Services database_services = new Database_Services();
  DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("Tap on '+' to add to list",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Edit_Text(documentSnapshot)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

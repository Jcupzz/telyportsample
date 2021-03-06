import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/Pages/DetailsPage.dart';
import 'package:telyportsample/Pages/DisplayNotesPage.dart';
import 'package:telyportsample/Pages/Edit_Text.dart';
import 'package:telyportsample/Pages/MyHomePage.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _page = 0;
  final pageOption = [
    MyHomePage(),
    DetailsPage(),
    Edit_Text(null),
    DisplayNotesPage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void setState(fn) async{
    // TODO: implement setState
    Database_Services database_services = new Database_Services();
    await database_services.signInAnonymously();
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueGrey[50],
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue[600],
        height: 60,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.add_circle_rounded,
            size: 20,
            color: Colors.white,
          ),

          Icon(
            Icons.notes_rounded,
            size: 20,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: pageOption[_page],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/main.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database_Services database_services = new Database_Services();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database_services.checkConnectivity(context);

  }




//Optional


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,10,10,10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Enable location tracking"),
                  Switch(
                    value: isSwitched,
                    onChanged: (value){
                      setState(() {
                        isSwitched = value;
                        if(isSwitched == true){
                          //TODO: START SERVICE
                          startLocation();
                        }
                        else{

                        }
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              Divider(height: 10,)
            ],
          ),

        ),
      ),
    );
  }

  void startLocation() {
      getPermission();
  }

  Future getPermission() async{
    Database_Services database_services = new Database_Services();
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);

      location.onLocationChanged.listen((LocationData currentLocation) {
      if(isSwitched) {
        database_services.addLocationToFb(currentLocation);
      }
      });


  }
}



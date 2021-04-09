import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/Static/Database_Helper.dart';
import 'package:telyportsample/Static/Location.dart';
import 'package:telyportsample/main.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database_Services database_services = new Database_Services();
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database_services.checkConnectivity(context);
  }


//Optional
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        if (isSwitched == true) {
                          //TODO: START SERVICE
                          startLocation();
                        }
                        else {

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

  Future getPermission() async {
    Database_Services database_services = new Database_Services();
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    var data;
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
    Database_Helper database_helper = new Database_Helper();
    location.onLocationChanged.listen((LocationData currentLocation) async{
      if (isSwitched) {
        if (database_services.checkConnectivity(context).toString() == "Connected") {
          database_services.addLocationToFb(currentLocation);
        }
        else {
          data = await database_helper.CreateDB();
          final fido = MyLocations(
            id: currentLocation.time.ceil(),
            lat: currentLocation.latitude.toString(),
            long: currentLocation.longitude.toString(),
          );
          await database_helper.insertLocation(fido, data);
        }
      }
    });
    if(data!=null){
      print(data);
      print(await database_helper.location(data));
    }
    else{
      print("null data");
    }
  }

}



import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:telyportsample/Database_Services/Database_Services.dart';
import 'package:telyportsample/main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  List<Marker> myMarker = [];
  Database_Services database_services = new Database_Services();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database_services.checkConnectivity(context);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  LatLng currentPostion;

  // void _getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  //   if (position != null) {
  //     setState(() {
  //       currentPostion = LatLng(position.latitude, position.longitude);
  //     });
  //   } else {
  //     setState(() {
  //       currentPostion = LatLng(56.53455, 65.4533434);
  //     });
  //   }
  // }

//Optional
  void _getAllLatLongFromFb() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection(firebaseUser.uid)
          .orderBy('time', descending: true)
          .limitToLast(5)
          .get()
          .then((QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((doc) {
                print(LatLng(doc['lat'], doc['long']));
                myMarker.add(Marker(
                    markerId: MarkerId(LatLng(doc['lat'], doc['long']).toString()),
                    onTap: () {
                      setState(() {});
                    },
                    position: LatLng(doc['lat'], doc['long']),
                    infoWindow: InfoWindow(title: 'location', snippet: doc['lat'].toString())));
              }));
    }
  }

  Future<Position> _getUserLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      BotToast.showText(text: 'Location services are disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      BotToast.showText(text: 'Location permissions are permantly denied, we cannot request permissions');
      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        BotToast.showText(text: 'Location permissions are denied (actual value: $permission)');
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAllLatLongFromFb();
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                          _getUserLocationPermission();
                          //_getUserLocation();
                          _getAllLatLongFromFb();
                        } else {}
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              Divider(
                height: 10,
              ),
              (isSwitched)
                  ? Expanded(
                      child: GoogleMap(
                      mapToolbarEnabled: true,
                      buildingsEnabled: true,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: Set.from(myMarker),
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(10.3098831, 76.3432708),
                        zoom: 6,
                      ),
                    ))
                  : Container()
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
      if (isSwitched) {
        database_services.addLocationToFb(currentLocation);
      }
    });
  }

}

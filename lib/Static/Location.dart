class MyLocations{

  final int id;
  final String lat;
  final String long;
  MyLocations({this.id,this.lat,this.long});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
    };
  }
}
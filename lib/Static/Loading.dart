import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
        color: Colors.blueGrey[50],
        child: Center(
          child: SpinKitRipple(
            color:Colors.blue,
            size: 80.0,
          ),
        ));
  }
}

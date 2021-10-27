import 'package:flutter/material.dart';
import '../utils/textStyles.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key}) : super(key: key);

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text(
          'Google Map View',
          style: titleBigStyle,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_testing_44/custom_google_map.dart';
import 'package:google_maps_testing_44/get_location.dart';

void main() {
  runApp(const GoogleMapsTesting());
}

class GoogleMapsTesting extends StatelessWidget {
  const GoogleMapsTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetLocation(),
      // home: CustomGoogleMap()
    );
  }
}

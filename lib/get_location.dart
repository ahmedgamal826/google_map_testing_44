import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  late loc.LocationData _currentLocation;
  bool _locationFetched = false;
  String _address = "Fetching address...";

  Future<void> _getLocation() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    _locationFetched = true;

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentLocation.latitude!,
      _currentLocation.longitude!,
    );
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      setState(() {
        _address =
            '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      });
    } else {
      setState(() {
        _address = 'Address not found';
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Current Address"),
        content: Text(_address),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToMap();
            },
            child: Text(
              "View on Map",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMap() {
    if (_locationFetched) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            locationData: _currentLocation,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Get Current Location',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: _getLocation,
          child: Text(
            'Get Location',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final loc.LocationData locationData;

  const MapScreen({required this.locationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Map View",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(locationData.latitude!, locationData.longitude!),
          ),
        },
      ),
    );
  }
}

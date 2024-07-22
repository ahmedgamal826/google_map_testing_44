
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {

  late CameraPosition initialCameraPosition;

  @override
  void initState() {

    initialCameraPosition = const CameraPosition(target:
    LatLng(31.190986131641274, 29.93009529426482),
      zoom: 10
    );
    initMapStyle();
    initMarkers();
    super.initState();
  }
  late GoogleMapController googleMapController;
   // Location location = Location();

  Set <Marker> markers = {};


  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
         // mapType: MapType.hybrid,
          onMapCreated: (controller)
          {
            googleMapController = controller;  // initialize the googleMapController
            initMapStyle();

          },
          // cameraTargetBounds: CameraTargetBounds(
          //     LatLngBounds(
          //         northeast: LatLng(31.33009460932349, 30.125102620220606),
          //         southwest: LatLng(30.979290528654623, 29.505748367638926),),
          // ),
          initialCameraPosition: initialCameraPosition,
        ),

        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: ()
            {
              CameraPosition newLocation =  const CameraPosition(
                target:
                LatLng(30.76263258423331, 30.22120509796435),
                zoom: 12
              );
              googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
            newLocation
                ),
              );
              
            },
            child: const Text('Change Location'
            ),
          ),
        )
      ],

    );
  }

  void initMapStyle() async
  {
    var nightMapStyle = await DefaultAssetBundle.of(context).
    loadString('assets/map_styles/night_map_style.json');

    googleMapController.setMapStyle(nightMapStyle);
  }

  void initMarkers()
  {
    var myMarker = const Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.190986131641274, 29.93009529426482));
    markers.add(myMarker);
  }
}

// Zoom Values
// 1- world view ==> zoom => 0 : 3
// 2- country view ==> zoom => 4 : 6
// 3- city view ==> zoom => 10 : 12
// 4- street view ==> zoom => 13 : 17
// 5- building view ==> zoom => 18 : 20
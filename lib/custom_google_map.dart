import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_testing_44/models/place_model.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        target: LatLng(31.190986131641274, 29.93009529426482), zoom: 6);
    initMapStyle();
    initMarkers();
    initPolyLines();
    initPolygons();
    initCircle();
    super.initState();
  }

  late GoogleMapController googleMapController;
  // Location location = Location();

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circle = {};

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
          polylines: polylines,
          markers: markers,
          polygons: polygons,
          circles: circle,
          // mapType: MapType.hybrid,
          onMapCreated: (controller) {
            googleMapController =
                controller; // initialize the googleMapController
            initMapStyle();
          },
          // cameraTargetBounds: CameraTargetBounds(
          //     LatLngBounds(
          //         northeast: LatLng(31.33009460932349, 30.125102620220606),
          //         southwest: LatLng(30.979290528654623, 29.505748367638926),),
          // ),
          initialCameraPosition: initialCameraPosition,
        ),

        // Positioned(
        //   bottom: 16,
        //   left: 16,
        //   right: 16,
        //   child: ElevatedButton(
        //     onPressed: ()
        //     {
        //       CameraPosition newLocation =  const CameraPosition(
        //         target:
        //         LatLng(30.76263258423331, 30.22120509796435),
        //         zoom: 12
        //       );
        //       googleMapController.animateCamera(
        //         CameraUpdate.newCameraPosition(
        //     newLocation
        //         ),
        //       );
        //
        //     },
        //     child: const Text('Change Location'
        //     ),
        //   ),
        // )
      ],
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');

    googleMapController.setMapStyle(nightMapStyle);
  }

  Future<Uint8List> getImageFromRowData(String image, double width) async {
    var imageData = await rootBundle.load(image);

    // إنشاء رمز الصورة باستخدام البيانات المحملة وتحديد العرض المطلوب
    var imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width.round(),
    );

    // الحصول على الإطار الأول من رمز الصورة
    // الحصول علي معلومات الصورة
    var imageFrameInfo = await imageCodec.getNextFrame();

    // تحويل الصورة إلى بيانات ثنائية باستخدام صيغة PNG
    var imageByData =
        await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    // التحقق من أن عملية التحويل نجحت قبل الوصول إلى البيانات

    return imageByData!.buffer.asUint8List();
  }

  void initMarkers() async {
    // Create one marker
    // var myMarker = const Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(31.190986131641274, 29.93009529426482));
    // markers.add(myMarker);

    var customMarkerIcon = BitmapDescriptor.fromBytes(
        await getImageFromRowData('assets/Images/marker_icon.png', 100));
    // var customMarkerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/Images/marker_icon.png');
    var myMarkers = places.map((placeModel) => Marker(
          icon: customMarkerIcon,
          infoWindow: InfoWindow(title: placeModel.name),
          markerId: MarkerId(placeModel.id.toString()),
          position: placeModel.latLng,
        ));

    markers.addAll(myMarkers);
    setState(() {});
  }

  void initPolyLines() {
    Polyline polyline1 = const Polyline(
        width: 5,
        //geodesic: true,
        zIndex: 2, // the second line created
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId('1'),
        color: Colors.blue,
        points: [
          LatLng(30.150815650326667, 30.938221807307883),
          LatLng(30.388027952493566, 30.317494235183418),
          LatLng(30.922007273442244, 30.92174231424263),
          LatLng(31.279478253023033, 30.191151455016488)
        ]);

    polylines.add(polyline1);

    Polyline polyline2 = const Polyline(
        width: 10,
        geodesic: true, // if the distance is far,put curve for the line
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        zIndex: 1, // the first line created
        polylineId: PolylineId('2'),
        color: Colors.green,
        points: [
          // LatLng(-30.300823371527077, 19.59483773765754),
          // LatLng(83.97272072154651, 34.36046335559447),

          LatLng(30.871366803727412, 29.36810606976339),
          LatLng(30.81713011652831, 30.991336066406504),
        ]);

    polylines.add(polyline2);
  }

  void initPolygons() {
    Polygon polygon = Polygon(
        holes: const [
          [
            LatLng(29.966419065856574, 31.743854489508703),

            LatLng(29.458315870262613, 31.018756829827346),
            // LatLng(29.391332155246033, 30.562824207912833),
            LatLng(30.118584777264267, 31.259082755967064),
          ]
        ],
        fillColor: Colors.black.withOpacity(0.5),
        strokeWidth: 5,
        strokeColor: Colors.red,
        polygonId: const PolygonId('1'),
        points: const [
          LatLng(30.130462885505455, 31.45546337447619),
          LatLng(28.767241026530453, 31.037982901397836),
          LatLng(29.53959380903412, 28.93959421061477)
        ]);

    polygons.add(polygon);
  }

  void initCircle() {
    Circle sohagCircle = Circle(
        fillColor: Colors.black.withOpacity(0.5),
        circleId: const CircleId('1'),
        center: const LatLng(27.112335044897335, 32.224511765470794),
        radius: 100000);

    circle.add(sohagCircle);
  }
}

// Zoom Values
// 1- world view ==> zoom => 0 : 3
// 2- country view ==> zoom => 4 : 6
// 3- city view ==> zoom => 10 : 12
// 4- street view ==> zoom => 13 : 17
// 5- building view ==> zoom => 18 : 20

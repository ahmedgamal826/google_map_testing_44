import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id,
    required this.name,
    required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name:  'مستشفي القباري التخصصي',
    latLng: const LatLng(31.173274239693438, 29.876024062381376),
  ),
  PlaceModel(
    id: 2,
    name: 'ستاد حرس الحدود',
    latLng: const LatLng(31.15300339456624, 29.850618177239117),
  ),
  PlaceModel(
    id: 3,
    name: 'قاعات سفير',
    latLng: const LatLng(31.1638738073237, 29.88555126930973),
  ),
  PlaceModel(
    id: 4,
    name: 'نجع العرب',
    latLng: const LatLng(31.15862237868136, 29.87409287166894),
  ),
];

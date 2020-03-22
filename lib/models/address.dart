import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final String city;
  final String state;
  final String street;
  final LatLng geolocation;
  final String formatted;
  final String postalCode;

  Address({
    this.city,
    this.state,
    this.street,
    this.geolocation,
    this.formatted,
    this.postalCode,
  });
}

import 'package:divoc/models/feed.dart';
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

  factory Address.fromFeed(Feed feed) {
    return Address(
      city: feed.city,
      state: feed.state,
      street: feed.street,
      postalCode: feed.postalCode,
      geolocation: LatLng(feed.geolocation.latitude, feed.geolocation.longitude),
    );
  }

  factory Address.fromMap(Map data) {
    return Address(
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      street: data['street'] ?? '',
      postalCode: data['postalCode'] ?? '',
      geolocation: data['geolocation'] ?? null,
    );
  }
}

import 'package:divoc/models/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  Future<Address> getCurrentLocation() async {
    try {
      Position res = await Geolocator().getCurrentPosition();
      List<Placemark> placemarks =
      await Geolocator().placemarkFromPosition(res);
      Placemark placemark = placemarks.first;
      String street = placemark.thoroughfare + ' ' + placemark.subThoroughfare;
      String postalCode = placemark.postalCode;
      String state = placemark.subLocality;
      String city = placemark.administrativeArea;
      String formatted =
          street + ', ' + postalCode + ', ' + state + ', ' + city;
      return Address(
        state: state,
        city: city,
        postalCode: postalCode,
        geolocation: LatLng(res.latitude, res.longitude),
        street: street,
        formatted: formatted,
      );
    } catch (error) {
      print("Could not detect current user location");
      return null;
    }
  }
}
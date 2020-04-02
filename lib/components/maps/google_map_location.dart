import 'package:divoc/common/loader.dart';
import 'package:divoc/components/maps/internal/geolocation.dart';
import 'package:divoc/components/maps/internal/place.dart';
import 'package:divoc/components/maps/internal/search_map_place.dart';
import 'package:divoc/models/address.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:divoc/services/utils.dart';

class GoogleMapLocation extends StatefulWidget {
  final Function(Address) onSelected;

  const GoogleMapLocation({this.onSelected});

  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  GoogleMapController _controller;
  Address _address;
  Set<Marker> _markers = <Marker>[
    Marker(markerId: MarkerId("marker_1"), position: _kLocation)
  ].toSet();
  String _placeholder;
  bool _isLoading;

  /// Current location
  Position _currentPosition;

  static final LatLng _kLocation = LatLng(59.337274, 18.067193);

  CameraPosition _kStartCameraPosition = CameraPosition(
    target: _kLocation,
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      _controller = controllerParam;
    });
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers = <Marker>[
        Marker(
          markerId: MarkerId("marker_1"),
          position: position,
          infoWindow: InfoWindow(title: 'Home'),
        )
      ].toSet();
    });
  }

  void getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
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
      setState(() {
        _address = Address(
          state: state,
          city: city,
          postalCode: postalCode,
          geolocation: LatLng(res.latitude, res.longitude),
          street: street,
          formatted: formatted,
        );
        _placeholder = formatted;
        _currentPosition = res;
        _kStartCameraPosition = CameraPosition(
          target: LatLng(res.latitude, res.longitude),
          zoom: 14.4746,
        );
      });
      _updateMarker(LatLng(res.latitude, res.longitude));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      /// Location permission denied
      setState(() {
        _placeholder = 'Skriv in adress';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Skriv in adress'),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kStartCameraPosition,
              markers: _markers,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
            Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width * 0.05,
              child: SearchMapPlaceWidget(
                placeholder: _placeholder,
                apiKey: "AIzaSyCbr_dJZ6aQorm5JC2l31lzC2QnRNuMzWA",
                location: _kStartCameraPosition.target,
                radius: 30000,
                sessionToken: Uuid().v4(),
                onSelected: (place) async {
                  FocusScope.of(context).unfocus();
                  final geolocation = await place.geolocation;
                  final List<dynamic> types = geolocation.fullJSON["types"];
                  var found = types
                      .where((element) => element == 'street_address')
                      .toList();
                  if (found.length == 0) {
                    setState(() {
                      _address = null;
                    });
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Välj en giltig address')));
                    return;
                  }

                  final String streetAddress = geolocation
                      .fullJSON["address_components"][1]["short_name"];
                  final String streetNumber = geolocation
                      .fullJSON["address_components"][0]["short_name"];
                  final String street = streetAddress + " " + streetNumber;
                  final String state = geolocation
                      .fullJSON["address_components"][2]["short_name"];
                  final String city = geolocation.fullJSON["address_components"]
                      [4]["short_name"];
                  final String postalCode = geolocation
                      .fullJSON["address_components"][6]["short_name"];

                  _address = Address(
                    street: street,
                    state: state,
                    city: city,
                    geolocation: geolocation.coordinates,
                    postalCode: postalCode,
                    formatted: geolocation.fullJSON["formatted_address"],
                  );

                  await _controller.animateCamera(
                      CameraUpdate.newLatLng(geolocation.coordinates));
                  await _controller.animateCamera(
                      CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                  _updateMarker(geolocation.coordinates);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _address != null && !_address.street.isNullOrEmpty
          ? FloatingActionButton.extended(
              icon: Icon(Icons.place),
              label: Text('Välj plats'),
              onPressed: () {
                if (_address != null) {
                  widget.onSelected(_address);
                  Navigator.pop(context);
                }
              },
            )
          : Container(),
    );
  }
}

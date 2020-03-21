import 'dart:async';

import 'package:divoc/components/maps/search_map_place.dart';
import 'package:divoc/models/address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapLocation extends StatefulWidget {
  final Function(Address) onSelected;

  const GoogleMapLocation({this.onSelected});

  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  Completer<GoogleMapController> _controller = Completer();
  Address _address;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Enter Location'),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            // width: MediaQuery.of(context).size.width * 0.9,
            child: SearchMapPlaceWidget(
              apiKey: "AIzaSyDMIxb_SbJ2e0RLPdHRjlEp6LgYvUwoUf4",
              location: _kGooglePlex.target,
              radius: 30000,
              onSelected: (place) async {
                FocusScope.of(context).unfocus();
                final geolocation = await place.geolocation;
                final GoogleMapController controller = await _controller.future;

                final String streetAddress = geolocation.fullJSON["address_components"][1]["short_name"];
                final String streetNumber = geolocation.fullJSON["address_components"][0]["short_name"];
                final String street = streetAddress + " " + streetNumber;
                final String state = geolocation.fullJSON["address_components"][2]["short_name"];
                final String city = geolocation.fullJSON["address_components"][4]["short_name"];

                _address = Address(street: street, state: state, city: city, geolocation: geolocation.coordinates);

                controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.place),
        label: Text('Select'),
        onPressed: () {
          if (_address != null) {
            widget.onSelected(_address);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

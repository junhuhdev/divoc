import 'dart:async';

import 'package:divoc/components/maps/internal/search_map_place.dart';
import 'package:divoc/models/address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class GoogleMapLocation extends StatefulWidget {
  final Function(Address) onSelected;

  const GoogleMapLocation({this.onSelected});

  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  GoogleMapController _controller;
  Address _address;
  Set<Marker> _markers = <Marker>[Marker(markerId: MarkerId("marker_1"), position: _kLocation)].toSet();

  static final LatLng _kLocation = LatLng(59.337274, 18.067193);

  static final CameraPosition kStartCameraPosition = CameraPosition(
    target: _kLocation,
    zoom: 14.4746,
  );

  @override
  void dispose() {
    super.dispose();
  }

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
        )
      ].toSet();
    });
  }

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
            initialCameraPosition: kStartCameraPosition,
            markers: _markers,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey: "AIzaSyCbr_dJZ6aQorm5JC2l31lzC2QnRNuMzWA",
              location: kStartCameraPosition.target,
              radius: 30000,
              sessionToken: Uuid().v4(),
              onSelected: (place) async {
                FocusScope.of(context).unfocus();
                final geolocation = await place.geolocation;

                final String streetAddress = geolocation.fullJSON["address_components"][1]["short_name"];
                final String streetNumber = geolocation.fullJSON["address_components"][0]["short_name"];
                final String street = streetAddress + " " + streetNumber;
                final String state = geolocation.fullJSON["address_components"][2]["short_name"];
                final String city = geolocation.fullJSON["address_components"][4]["short_name"];
                final String postalCode = geolocation.fullJSON["address_components"][6]["short_name"];

                _address = Address(
                  street: street,
                  state: state,
                  city: city,
                  geolocation: geolocation.coordinates,
                  postalCode: postalCode,
                  formatted: geolocation.fullJSON["formatted_address"],
                );

                await _controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                await _controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                _updateMarker(geolocation.coordinates);
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

import 'package:divoc/models/address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapBox extends StatefulWidget {
  final Address address;

  const GoogleMapBox({this.address});

  @override
  _GoogleMapBoxState createState() => _GoogleMapBoxState();
}

class _GoogleMapBoxState extends State<GoogleMapBox> {
  GoogleMapController _controller;

  LatLng _kLocation;
  CameraPosition _kStartCameraPosition;
  Set<Marker> _markers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _kLocation = LatLng(widget.address.geolocation.latitude, widget.address.geolocation.longitude);
    _kStartCameraPosition = CameraPosition(
      target: _kLocation,
      zoom: 14.4746,
    );
    _markers = <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: _kLocation,
      )
    ].toSet();
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      _controller = controllerParam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: SizedBox(
              height: 250.0,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kStartCameraPosition,
                markers: _markers,
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Address: ${widget.address.street}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Postal Code: ${widget.address.postalCode}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "State: ${widget.address.state}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "City: ${widget.address.city}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

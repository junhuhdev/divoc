import 'package:divoc/components/maps/static/static_map_provider.dart';
import 'package:divoc/components/maps/static/static_marker.dart';
import 'package:divoc/models/address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticGoogleMap extends StatelessWidget {
  final String apiKey;
  final Address address;

  const StaticGoogleMap({this.apiKey, this.address});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final StaticMarker _marker = new StaticMarker(
      "place",
      "Google",
      address.geolocation.latitude,
      address.geolocation.longitude,
      color: theme.accentColor,
    );
    var staticMapProvider = new StaticMapProvider(apiKey);
    Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([_marker], 17, width: 900, height: 450);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: SizedBox(
              height: 300.0,
              child: new Image.network(staticMapUri.toString()),
            ),
          ),
        ),
      ],
    );
  }
}

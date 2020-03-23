class StaticLocation {
  static const DROID_KAIGI_2018 =
  const StaticLocation(35.6957954, 139.69038920000003);

  final double latitude;
  final double longitude;

  const StaticLocation(this.latitude, this.longitude);
  factory StaticLocation.fromMap(Map map) {
    return new StaticLocation(map["latitude"], map["longitude"]);
  }

  Map toMap() {
    return {"latitude": this.latitude, "longitude": this.longitude};
  }

  @override
  String toString() {
    return 'Location{latitude: $latitude, longitude: $longitude}';
  }
}

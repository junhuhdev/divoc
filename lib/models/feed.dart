import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String shoppingInfo;
  final String mobile;
  final int age;
  final String gender;
  final String image;
  final String city;
  final String state;
  final String street;
  final String postalCode;
  final String category;
  final GeoPoint geolocation;
  final int severity;

  /// created, pending, complete
  final String status;
  final Map requestedUsers;
  final DateTime created;

  Feed({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.shoppingInfo,
    this.mobile,
    this.age,
    this.gender,
    this.image,
    this.city,
    this.state,
    this.street,
    this.postalCode,
    this.category,
    this.geolocation,
    this.severity,
    this.status,
    this.requestedUsers,
    this.created,
  });

  factory Feed.fromMap(Map data, String id) {
    return Feed(
      id: id ?? '',
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      shoppingInfo: data['shoppingInfo'] ?? '',
      mobile: data['mobile'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      image: data['image'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      street: data['street'] ?? '',
      postalCode: data['postalCode'] ?? '',
      category: data['category'] ?? '',
      geolocation: data['geolocation'] ?? null,
      severity: data['severity'] ?? 0,
      status: data['status'] ?? '',
      requestedUsers: data['requestedUsers'] ?? new Map(),
      created: data['created'] == null ? DateTime.now() : data['created'].toDate(),
    );
  }
}

class FeedStatus {
  static const created = "created";
  static const pending = "pending";
  static const delivered = "delivered";
  static const completed = "completed";
}

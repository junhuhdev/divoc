import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String deliveryUserId;
  final String deliveryInfo;
  final String deliveredComment;
  final double totalCost;
  final String mobile;
  final int age;
  final String gender;
  final String image;
  final String recipeImage;
  final String city;
  final String state;
  final String street;
  final String postalCode;
  final String category;
  final GeoPoint geolocation;
  final int severity;

  /// created, pending, completed
  final String status;
  final Map requestedUsers;
  final DateTime created;

  Feed({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.deliveryUserId,
    this.deliveryInfo,
    this.deliveredComment,
    this.totalCost,
    this.mobile,
    this.age,
    this.gender,
    this.image,
    this.recipeImage,
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

  String get formattedAddress {
    return street + ', ' + postalCode + ', ' + state + ', ' + city;
  }

  factory Feed.fromMap(Map data, String id) {
    return Feed(
      id: id ?? '',
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      deliveryUserId: data['deliveryUserId'] ?? '',
      deliveryInfo: data['deliveryInfo'] ?? '',
      deliveredComment: data['deliveredComment'] ?? '',
      totalCost: data['totalCost'] ?? 0,
      mobile: data['mobile'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      image: data['image'] ?? '',
      recipeImage: data['recipeImage'] ?? '',
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

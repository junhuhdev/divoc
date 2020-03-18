class Feed {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String mobile;
  final int age;
  final String gender;
  final String image;
  final String city;
  final String state;
  final String category;
  final int severity;
  final String status;
  final Map requestedUsers;
  final DateTime created;

  Feed({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.mobile,
    this.age,
    this.gender,
    this.image,
    this.city,
    this.state,
    this.category,
    this.severity,
    this.status,
    this.requestedUsers,
    this.created,
  });

  factory Feed.fromMap(Map data, id) {
    return Feed(
      id:  id ?? '',
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      mobile: data['mobile'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      image: data['image'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      category: data['category'] ?? '',
      severity: data['severity'] ?? 0,
      status: data['status'] ?? '',
      requestedUsers: data['requestedUsers'] ?? new Map(),
      created:  DateTime.now(),
    );
  }
}

class FeedStatus {
  static const created = "created";
  static const pending = "pending";
  static const delivered = "delivered";
  static const completed = "completed";
}
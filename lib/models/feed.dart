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
    this.created,
  });

  factory Feed.fromMap(Map data) {
    return Feed(
      id: data['id'] ?? '',
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      mobile: data['mobile'] ?? '',
      age: data['age'] ?? '',
      gender: data['gender'] ?? '',
      image: data['image'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      category: data['category'] ?? '',
      severity: data['severity'] ?? '',
      created: data['created'] ?? '',
    );
  }
}

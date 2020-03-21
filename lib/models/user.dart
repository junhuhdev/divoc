class User {
  final String id;
  final String photo;
  final String name;
  final String email;
  final String city;
  final String state;
  final DateTime birthdate;
  final String mobile;
  final String gender;

  User({
    this.id,
    this.photo,
    this.name,
    this.email,
    this.city,
    this.state,
    this.birthdate,
    this.mobile,
    this.gender,
  });

  factory User.fromMap(Map data, String id) {
    return User(
      id: data['id'] ?? '',
      photo: data['photo'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      birthdate: data['birthdate'] == null ? DateTime.now() : data['birthdate'].toDate(),
      mobile: data['mobile'] ?? '',
      gender: data['gender'] ?? '',
    );
  }
}

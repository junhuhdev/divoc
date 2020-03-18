class User {
  final String id;
  final String photo;
  final String name;
  final String email;
  final String city;
  final String state;
  final String birthdate;
  final String mobile;

  User({
    this.id,
    this.photo,
    this.name,
    this.email,
    this.city,
    this.state,
    this.birthdate,
    this.mobile,
  });

  factory User.fromMap(Map data, String id) {
    return User(
        id: data['id'] ?? '',
        photo: data['photo'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        city: data['city'] ?? '',
        state: data['state'] ?? '',
        birthdate: data['birthdate'] ?? '',
        mobile: data['mobile'] ?? '');
  }
}

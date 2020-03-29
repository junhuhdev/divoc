class User {
  final String id;
  final String photo;
  final String name;
  final String email;
  final String city;
  final String state;
  final int age;
  final DateTime birthdate;
  final String mobile;
  final String gender;
  final String provider;

  User({
    this.id,
    this.photo,
    this.name,
    this.email,
    this.city,
    this.state,
    this.age,
    this.birthdate,
    this.mobile,
    this.gender,
    this.provider,
  });

  factory User.fromMap(Map data, String id) {
    return User(
      id: data['id'] ?? '',
      photo: data['photo'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      age: data['birthdate'] == null ? 0 : calculateAge(data['birthdate'].toDate()),
      birthdate: data['birthdate'] == null ? DateTime.now() : data['birthdate'].toDate(),
      mobile: data['mobile'] ?? '',
      gender: data['gender'] ?? '',
    );
  }

  int get getAge {
    return calculateAge(this.birthdate);
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}

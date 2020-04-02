import 'package:divoc/services/utils.dart';

class User {
  final String id;
  final String photo;
  final String name;
  final String email;
  final String city;
  final String street;
  final String postalCode;
  final String state;
  final int age;
  final DateTime birthdate;
  final String mobile;
  final String gender;

  /// giver | receiver
  final String role;
  final String provider;

  User({
    this.id,
    this.photo,
    this.name,
    this.email,
    this.city,
    this.street,
    this.postalCode,
    this.state,
    this.age,
    this.birthdate,
    this.mobile,
    this.gender,
    this.role,
    this.provider,
  });

  factory User.fromMap(Map data, String id) {
    return User(
      id: data['id'] ?? '',
      photo: data['photo'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      street: data['street'] ?? '',
      postalCode: data['postalCode'] ?? '',
      state: data['state'] ?? '',
      age: data['birthdate'] == null ? 0 : calculateAge(data['birthdate'].toDate()),
      birthdate: data['birthdate'] == null ? DateTime.now() : data['birthdate'].toDate(),
      mobile: data['mobile'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
    );
  }

  bool get isHelper {
    return !role.isNullOrEmpty  && role == 'giver';
  }

  String get fromRole {
    if (!role.isNullOrEmpty && role == "giver") {
      return "Medhjälpare";
    } else {
      return "Mottagare";
    }
  }

  static String toRole(String val) {
    if (!val.isNullOrEmpty && val == 'Medhjälpare') {
      return "giver";
    } else if (!val.isNullOrEmpty && val == 'Mottagare') {
      return "receiver";
    } else {
      return "giver";
    }
  }

  static String toRoleOrNull(String val) {
    if (!val.isNullOrEmpty && val == 'Medhjälpare') {
      return "giver";
    } else if (!val.isNullOrEmpty && val == 'Mottagare') {
      return "receiver";
    } else {
      return null;
    }
  }


  static const USER_ROLES = ['Medhjälpare', 'Mottagare'];

  String get formattedAddress {
    if (street.isNullOrEmpty || postalCode.isNullOrEmpty) {
      return "";
    }
    return street + ', ' + postalCode + ', ' + state + ', ' + city;
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

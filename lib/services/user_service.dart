import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user.dart';

class UserService {
  final Firestore _db = Firestore.instance;

  Stream<List<User>> streamTopUsers() {
    var ref = _db.collection('users').limit(50);
    return ref.snapshots().map((list) => list.documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList());
  }

  /// Calculates age based on birthdate
  int calculateAge(DateTime birthDate) {
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

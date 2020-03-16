import 'package:divoc/models/user.dart';
import 'package:divoc/services/db.dart';

class Global {
  static final Map models = {
    User: (data) => User.fromMap(data),
  };

  static final Collection<User> usersCollecion = Collection<User>(path: 'users');
  static final UserData<User> userDoc = UserData<User>(collection: 'users');
}

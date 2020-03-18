import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/db.dart';

class Global {
  static final Map models = {
    User: (data, id) => User.fromMap(data, id),
    Feed: (data, id) => Feed.fromMap(data, id),
  };

  static final Collection<User> usersCollecion = Collection<User>(path: 'users');
  static final UserData<User> userDoc = UserData<User>(collection: 'users');
  static final Collection<Feed> feedCollection = Collection<Feed>(path: 'feeds');
}

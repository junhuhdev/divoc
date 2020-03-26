import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/db.dart';

class Global {
  static final Map models = {
    User: (data, id) => User.fromMap(data, id),
    Feed: (data, id) => Feed.fromMap(data, id),
    FeedRequest: (data, id) => FeedRequest.fromMap(data, id),
  };

  static final UserData<User> userDoc = UserData<User>(collection: 'users');
  static final Collection<Feed> feedCollection = Collection<Feed>(path: 'feeds');
  static final Collection<User> usersCollection = Collection<User>(path: 'users');

}

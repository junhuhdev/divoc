import 'package:divoc/models/user.dart';

class Global {
  static final Map models = {
    User: (data) => User.fromMap(data),
  };
}

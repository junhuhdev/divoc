import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user_comment.dart';

class UserCommentService {
  final Firestore _db = Firestore.instance;

  Future<void> insertComment(UserComment userComment) async {
    await _db.collection('comments').document(userComment.feedId).collection('comments').add(
          ({
            'feedId': userComment.feedId,
            'userId': userComment.userId,
            'userName': userComment.userName,
            'userImage': userComment.userImage,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': userComment.content,
          }),
        );
  }
}

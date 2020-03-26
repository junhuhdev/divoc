import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user_comment.dart';

class UserCommentService {
  final Firestore _db = Firestore.instance;

  Stream<List<UserComment>> streamComments(String feedId) {
    var ref = _db
        .collection('comments')
        .document(feedId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .limit(20);

    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => UserComment.fromMap(doc.data, doc.documentID)).toList());
  }

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

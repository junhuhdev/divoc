import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/models/user.dart';

class FeedService {
  final Firestore _db = Firestore.instance;

  Stream<List<Feed>> streamOwnerFeeds(String userId) {
    var ref = _db.collection('feeds').where('ownerId', isEqualTo: userId).limit(100);
    return ref.snapshots().map((list) => list.documents.map((doc) => Feed.fromMap(doc.data, doc.documentID)).toList());
  }

  Stream<List<FeedRequest>> streamFeedRequests(String userId) {
    var ref = _db.collectionGroup('requests').where('userId', isEqualTo: userId);
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => FeedRequest.fromMap(doc.data, doc.documentID)).toList());
  }

  Future<void> updateRequestedUser(String feedId, User currentUser) async {
    await Firestore.instance
        .collection('feeds')
        .document(feedId)
        .updateData({'requestedUsers.${currentUser.id}': true});

    await Firestore.instance.collection('feeds').document(feedId).collection('requests').add(
          ({
            'userId': currentUser.id,
            'name': currentUser.name,
            'created': DateTime.now(),
          }),
        );
  }
}

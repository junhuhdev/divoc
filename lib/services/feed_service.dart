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

  /// When user accepts help from another user
  Future<void> acceptUserRequest(String feedId, String helperUserId) async {
    await _db.collection('feeds').document(feedId).updateData({'status': 'pending'});
    await _db.collection('feeds').document(feedId).collection('requests').document(helperUserId).updateData(
          ({
            'status': 'pending',
          }),
        );
  }

  /// When user wants to help
  Future<void> updateRequestedUser(String feedId, User currentUser) async {
    await _db.collection('feeds').document(feedId).updateData({'requestedUsers.${currentUser.id}': true});

    await _db.collection('feeds').document(feedId).collection('requests').document(currentUser.id).setData(
          ({
            'userId': currentUser.id,
            'name': currentUser.name,
            'ownerName': 'Petra',
            'status': 'requested',
            'created': DateTime.now(),
          }),
        );
  }

  /// Delete user's own feed
  Future<void> deleteFeed(String feedId) async {
    await _db.collection('feeds').document(feedId).delete();
    print("Deleted feed $feedId");
  }
}

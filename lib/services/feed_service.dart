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
  Future<void> updateRequestedUser(String feedId, User currentUser, Feed feed) async {
    await _db.collection('feeds').document(feedId).updateData({'requestedUsers.${currentUser.id}': true});

    await _db.collection('feeds').document(feedId).collection('requests').document(currentUser.id).setData(
          ({
            'userId': currentUser.id,
            'name': currentUser.name,
            'status': 'requested',
            'ownerName': feed.name,
            'feedId': feed.id,
            'image': feed.image,
            'city': feed.city,
            'state': feed.state,
            'created': DateTime.now(),
          }),
        );
  }

  Future<void> updateFeed(String feedId, Feed feed) async {
    await _db.collection('feeds').document(feedId).updateData(
          ({
            'name': feed.name,
            'mobile': feed.mobile,
            'category': feed.category,
            'description': feed.description,
            'deliveryInfo': feed.deliveryInfo,
            'city': feed.city,
            'state': feed.state,
            'street': feed.street,
            'postalCode': feed.postalCode,
            'geolocation': feed.geolocation,
          }),
        );
  }

  /// Delete user's own feed
  Future<void> deleteFeed(String feedId) async {
    await _db.collection('feeds').document(feedId).delete();
    print("Deleted feed $feedId");
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/models/user.dart';

class FeedService {
  final Firestore _db = Firestore.instance;

  Stream<List<Feed>> streamFeeds() {
    var ref =
        _db.collection('feeds').where('status', isEqualTo: 'created').orderBy('created', descending: true).limit(100);
    return ref.snapshots().map((list) => list.documents.map((doc) => Feed.fromMap(doc.data, doc.documentID)).toList());
  }

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

  Future<void> deliveryCompleted(Feed feed, User currentUser, String totalCost, String comment) async {
    await _db.collection('feeds').document(feed.id).updateData(
      {
        'deliveredComment': comment,
        'totalCost': double.parse(totalCost),
        'status': 'completed',
      },
    );
    await _db.collection('feeds').document(feed.id).collection('requests').document(currentUser.id).updateData(
          ({
            'status': 'completed',
          }),
        );
  }

  /// When user accepts help from another user
  Future<void> acceptUserRequest(String feedId, String helperUserId) async {
    await _db.collection('feeds').document(feedId).updateData(
      {
        'deliveryUserId': helperUserId,
        'status': 'pending',
      },
    );
    await _db.collection('feeds').document(feedId).collection('requests').document(helperUserId).updateData(
          ({
            'status': 'pending',
          }),
        );
  }

  /// When user denies help from another user
  Future<void> denyUserRequest(String feedId, String helperUserId) async {
    FieldValue decrement = FieldValue.increment(-1);

    await _db.collection('feeds').document(feedId).updateData(
      {
        'totalRequests': decrement,
      },
    );

    await _db.collection('feeds').document(feedId).collection('requests').document(helperUserId).delete();
  }

  /// When user wants to help
  Future<void> updateRequestedUser(User currentUser, Feed feed, String comment, String mobile) async {
    FieldValue increment = FieldValue.increment(1);

    await _db.collection('feeds').document(feed.id).updateData(
      {
        'totalRequests': increment,
        'requestedUsers.${currentUser.id}': true,
      },
    );

    await _db.collection('feeds').document(feed.id).collection('requests').document(currentUser.id).setData(
          ({
            'userId': currentUser.id,
            'ownerId': feed.ownerId,
            'ownerName': feed.name,
            'ownerImage': feed.image,
            'ownerCity': feed.city,
            'ownerState': feed.state,
            'name': currentUser.name,
            'image': currentUser.photo,
            'mobile': currentUser.mobile,
            'city': currentUser.city,
            'state': currentUser.state,
            'status': 'requested',
            'comment': comment,
            'feedId': feed.id,
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

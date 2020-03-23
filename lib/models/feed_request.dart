/// TODO: save Id as userId in firestore
class FeedRequest {
  final String id;
  final String feedId;
  final String userId;
  final String name;
  final String ownerName;

  /// requested, pending, completed
  final String status;
  final DateTime created;

  FeedRequest({
    this.id,
    this.feedId,
    this.userId,
    this.name,
    this.ownerName,
    this.status,
    this.created,
  });

  factory FeedRequest.fromMap(Map data, String id) {
    return FeedRequest(
      id: id ?? '',
      feedId: data['feedId'] ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      ownerName: data['ownerName'] ?? '',
      status: data['status'] ?? '',
      created: data['created'].toDate() ?? DateTime.now(),
    );
  }
}

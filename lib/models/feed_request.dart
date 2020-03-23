/// TODO: save Id as userId in firestore
class FeedRequest {
  final String id;
  final String feedId;
  final String userId;
  final String name;
  final String ownerName;
  final String city;
  final String state;
  final String image;

  /// requested, pending, completed
  final String status;
  final DateTime created;

  FeedRequest({
    this.id,
    this.feedId,
    this.userId,
    this.name,
    this.ownerName,
    this.city,
    this.state,
    this.status,
    this.image,
    this.created,
  });

  factory FeedRequest.fromMap(Map data, String id) {
    return FeedRequest(
      id: id ?? '',
      feedId: data['feedId'] ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      ownerName: data['ownerName'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? '',
      created: data['created'].toDate() ?? DateTime.now(),
    );
  }
}

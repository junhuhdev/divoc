/// TODO: save Id as userId in firestore
class FeedRequest {
  final String id;
  final String feedId;
  final String userId;
  final String ownerId;
  final String ownerName;
  final String ownerImage;
  final String ownerCity;
  final String ownerState;
  final String name;
  final String mobile;
  final String comment;
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
    this.ownerId,
    this.ownerName,
    this.ownerImage,
    this.ownerCity,
    this.ownerState,
    this.name,
    this.mobile,
    this.comment,
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
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerImage: data['ownerImage'] ?? '',
      ownerCity: data['ownerCity'] ?? '',
      ownerState: data['ownerState'] ?? '',
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      comment: data['comment'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? '',
      created: data['created'].toDate() ?? DateTime.now(),
    );
  }
}

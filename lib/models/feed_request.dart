class FeedRequest {
  final String id;
  final String userId;
  final String name;
  final DateTime created;

  FeedRequest({
    this.id,
    this.userId,
    this.name,
    this.created,
  });

  factory FeedRequest.fromMap(Map data, id) {
    return FeedRequest(
      id:  id ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      created: data['created'].toDate() ?? DateTime.now(),
    );
  }
}

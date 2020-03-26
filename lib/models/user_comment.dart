class UserComment {
  final String id;
  final String feedId;
  final String userId;
  final String name;
  final String timestamp;
  final String content;

  UserComment({
    this.id,
    this.feedId,
    this.userId,
    this.name,
    this.timestamp,
    this.content,
  });

  factory UserComment.fromMap(Map data, String id) {
    return UserComment(
      id: data['id'] ?? '',
      feedId: data['feedId'] ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      timestamp: data['timestamp'] ?? '',
      content: data['content'] ?? '',
    );
  }
}

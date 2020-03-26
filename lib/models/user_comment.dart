class UserComment {
  final String id;
  final String userId;
  final String timestamp;
  final String content;

  UserComment({this.id, this.userId, this.timestamp, this.content});

  factory UserComment.fromMap(Map data, String id) {
    return UserComment(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? '',
      content: data['content'] ?? '',
    );
  }
}

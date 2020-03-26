class UserComment {
  final String id;
  final String feedId;
  final String userId;
  final String userName;
  final String userImage;
  final String timestamp;
  final String content;

  UserComment({
    this.id,
    this.feedId,
    this.userId,
    this.userName,
    this.userImage,
    this.timestamp,
    this.content,
  });

  factory UserComment.fromMap(Map data, String id) {
    return UserComment(
      id: data['id'] ?? '',
      feedId: data['feedId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      timestamp: data['timestamp'] ?? '',
      content: data['content'] ?? '',
    );
  }
}

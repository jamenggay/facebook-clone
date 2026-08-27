class Comment {
  final int id;
  final int postId;
  final String body;
  final int likes;
  final int userId;
  final String username;
  final String fullName;

  Comment({
    required this.id,
    required this.postId,
    required this.body,
    this.likes = 0,
    this.userId = 0,
    this.username = '',
    this.fullName = '',
  });

  String get image =>
      username.isEmpty ? '' : 'https://dummyjson.com/icon/$username/128';

  factory Comment.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : {};

    return Comment(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      body: json['body'] ?? '',
      likes: json['likes'] ?? 0,
      userId: user['id'] ?? 0,
      username: user['username'] ?? '',
      fullName: user['fullName'] ?? '',
    );
  }
}

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.tags = const [],
    this.likes = 0,
    this.dislikes = 0,
    this.views = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> reactions = json['reactions'] is Map
        ? Map<String, dynamic>.from(json['reactions'])
        : {};

    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: json['tags'] is List
          ? List<String>.from(json['tags'].map((t) => t.toString()))
          : const [],
      likes: reactions['likes'] ?? 0,
      dislikes: reactions['dislikes'] ?? 0,
      views: json['views'] ?? 0,
    );
  }
}

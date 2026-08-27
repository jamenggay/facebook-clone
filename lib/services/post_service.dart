import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  Future<List<Post>> getPosts({int limit = 20, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$host/posts?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    }
    throw Exception('Failed to load posts (${response.statusCode})');
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$host/posts/user/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    }
    throw Exception('Failed to load posts (${response.statusCode})');
  }
}

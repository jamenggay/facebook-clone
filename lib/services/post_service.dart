import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  Future<List<Post>> getPosts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$host/posts?limit=$limit&skip=$skip');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }
}

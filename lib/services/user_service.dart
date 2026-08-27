import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

class UserService {
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$host/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    }

    return null;
  }

  Future<User?> getUserById(int id) async {
    final response = await http.get(Uri.parse('$host/users/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  Future<String?> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$host/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      }
      return 'The server rejected the registration. Status code: '
          '${response.statusCode}';
    } catch (e) {
      return 'Could not reach the server. Please check your internet '
          'connection and try again.';
    }
  }

  Future<Map<int, User>> getAuthors() async {
    final response = await http.get(
      Uri.parse('$host/users?limit=0&select=firstName,lastName,username,image'),
    );

    final Map<int, User> authors = {};
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List usersJson = data['users'] ?? [];
      for (var json in usersJson) {
        final user = User.fromJson(json);
        authors[user.id] = user;
      }
    }
    return authors;
  }
}

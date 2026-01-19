import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class UserDatabase {
  static const String _fileName = 'users.json';
  static const String _dataFolder = 'data';

  // Get the file path where user data will be stored
  // Tries project folder first, falls back to app documents directory
  Future<File> _getFile() async {
    Directory dataDir;

    try {
      // Try to use project folder (works for desktop/web)
      final currentDir = Directory.current;
      final projectDataDir = Directory(path.join(currentDir.path, _dataFolder));

      // Check if we can write to the project directory
      if (await _canWriteToDirectory(projectDataDir)) {
        dataDir = projectDataDir;
      } else {
        // Fall back to app documents directory (works for all platforms)
        try {
          final appDir = await getApplicationDocumentsDirectory();
          dataDir = Directory(path.join(appDir.path, _dataFolder));
        } catch (e) {
          // If path_provider fails, try using current directory with better error handling
          throw Exception(
            'Cannot access app documents directory. Please restart the app completely. Error: $e',
          );
        }
      }
    } catch (e) {
      // If Directory.current fails, try app documents directory
      try {
        final appDir = await getApplicationDocumentsDirectory();
        dataDir = Directory(path.join(appDir.path, _dataFolder));
      } catch (e2) {
        // Last resort: try current directory
        final currentDir = Directory.current;
        dataDir = Directory(path.join(currentDir.path, _dataFolder));
      }
    }

    // Create data directory if it doesn't exist
    try {
      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }
    } catch (e) {
      throw Exception(
        'Cannot create data directory at ${dataDir.path}. Error: $e',
      );
    }

    return File(path.join(dataDir.path, _fileName));
  }

  // Check if we can write to a directory
  Future<bool> _canWriteToDirectory(Directory dir) async {
    try {
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      // Try to create a test file
      final testFile = File(path.join(dir.path, '.test_write'));
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get the file path as a string (useful for debugging)
  Future<String> getFilePath() async {
    final file = await _getFile();
    return file.path;
  }

  // Read all users from the file
  Future<List<Map<String, dynamic>>> readUsers() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isEmpty) {
          return [];
        }
        final List<dynamic> jsonData = json.decode(contents);
        return jsonData.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Re-throw exception so caller can handle it
      throw Exception('Failed to read users: ${e.toString()}');
    }
  }

  // Write a new user to the file
  // Returns null on success, or an error message string on failure
  Future<String?> saveUser({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String username,
    required String password,
  }) async {
    try {
      final file = await _getFile();
      List<Map<String, dynamic>> users;
      try {
        users = await readUsers();
      } catch (e) {
        // If file doesn't exist or can't be read, start with empty list
        users = [];
      }

      // Check if username already exists
      if (users.any(
        (user) => user['username']?.toString().trim() == username.trim(),
      )) {
        return 'Username already exists. Please choose a different username.';
      }

      // Create new user object
      final newUser = {
        'firstName': firstName,
        'lastName': lastName,
        'mobileNumber': mobileNumber,
        'username': username,
        'password': password, // In production, this should be hashed
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Add new user to the list
      users.add(newUser);

      // Write back to file
      await file.writeAsString(json.encode(users));
      return null; // Success
    } catch (e) {
      // Provide more detailed error message
      String errorMsg = e.toString();
      if (errorMsg.contains('MissingPluginException') ||
          errorMsg.contains('platform')) {
        return 'Plugin error: Please restart the app completely (stop and restart, not hot reload). Error: $errorMsg';
      }
      if (errorMsg.contains('PathAccessException') ||
          errorMsg.contains('Permission denied') ||
          errorMsg.contains('Access is denied')) {
        return 'Permission error: Cannot write to data directory. Please check app permissions. Error: $errorMsg';
      }
      if (errorMsg.contains('NoSuchMethodError') ||
          errorMsg.contains('getApplicationDocumentsDirectory')) {
        return 'Plugin not registered: Please stop the app completely and restart it (not hot reload). The path_provider plugin needs to be registered. Error: $errorMsg';
      }
      return 'Failed to save user: $errorMsg';
    }
  }

  // Find a user by username
  Future<Map<String, dynamic>?> findUserByUsername(String username) async {
    try {
      final users = await readUsers();
      if (users.isEmpty) {
        return null;
      }

      // Search for user with matching username (trimmed comparison)
      for (var user in users) {
        final storedUsername = user['username']?.toString().trim();
        if (storedUsername == username.trim()) {
          return user;
        }
      }
      return null; // User not found
    } catch (e) {
      return null;
    }
  }

  // Validate login credentials
  Future<bool> validateCredentials({
    required String username,
    required String password,
  }) async {
    try {
      // Read users directly to ensure we can access the file
      final users = await readUsers();

      if (users.isEmpty) {
        return false; // No users in database
      }

      // Find user with matching username
      final trimmedUsername = username.trim();
      Map<String, dynamic>? foundUser;

      for (var user in users) {
        final storedUsername = user['username']?.toString().trim();
        if (storedUsername == trimmedUsername) {
          foundUser = user;
          break;
        }
      }

      if (foundUser == null || foundUser.isEmpty) {
        return false; // User not found
      }

      // Check if password matches (exact match)
      final storedPassword = foundUser['password']?.toString();
      if (storedPassword == null) {
        return false;
      }

      return storedPassword == password;
    } catch (e) {
      // Re-throw the exception so login screen can handle it
      throw Exception('Failed to validate credentials: ${e.toString()}');
    }
  }

  // Get all users (for debugging/admin purposes)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await readUsers();
  }

  // Store the current logged-in username
  Future<void> setCurrentUser(String username) async {
    try {
      final file = await _getFile();
      final currentUserFile = File('${file.parent.path}/current_user.txt');
      await currentUserFile.writeAsString(username);
    } catch (e) {
      // Silently fail if we can't write
    }
  }

  // Get the current logged-in username
  Future<String?> getCurrentUser() async {
    try {
      final file = await _getFile();
      final currentUserFile = File('${file.parent.path}/current_user.txt');
      if (await currentUserFile.exists()) {
        final username = await currentUserFile.readAsString();
        return username.trim().isEmpty ? null : username.trim();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Clear the current logged-in user (for logout)
  Future<void> clearCurrentUser() async {
    try {
      final file = await _getFile();
      final currentUserFile = File('${file.parent.path}/current_user.txt');
      if (await currentUserFile.exists()) {
        await currentUserFile.delete();
      }
    } catch (e) {
      // Silently fail if we can't delete
    }
  }
}

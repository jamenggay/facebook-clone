import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SessionService {
  static const String _keyLoggedIn = 'isLoggedIn';
  static const String _keyId = 'userId';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyFirstName = 'firstName';
  static const String _keyLastName = 'lastName';
  static const String _keyGender = 'gender';
  static const String _keyImage = 'image';
  static const String _keyPhone = 'phone';
  static const String _keyAge = 'age';
  static const String _keyCity = 'city';
  static const String _keyCountry = 'country';
  static const String _keyCompany = 'company';
  static const String _keyJobTitle = 'jobTitle';
  static const String _keyUniversity = 'university';
  static const String _keyToken = 'token';

  static const String _keyDarkMode = 'darkMode';
  static const String _keyNotifications = 'notifications';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setInt(_keyId, user.id);
    await prefs.setString(_keyUsername, user.username);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyFirstName, user.firstName);
    await prefs.setString(_keyLastName, user.lastName);
    await prefs.setString(_keyGender, user.gender);
    await prefs.setString(_keyImage, user.image);
    await prefs.setString(_keyPhone, user.phone);
    await prefs.setInt(_keyAge, user.age);
    await prefs.setString(_keyCity, user.city);
    await prefs.setString(_keyCountry, user.country);
    await prefs.setString(_keyCompany, user.company);
    await prefs.setString(_keyJobTitle, user.jobTitle);
    await prefs.setString(_keyUniversity, user.university);
    await prefs.setString(_keyToken, user.token);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_keyLoggedIn) ?? false)) return null;

    return User(
      id: prefs.getInt(_keyId) ?? 0,
      username: prefs.getString(_keyUsername) ?? '',
      email: prefs.getString(_keyEmail) ?? '',
      firstName: prefs.getString(_keyFirstName) ?? '',
      lastName: prefs.getString(_keyLastName) ?? '',
      gender: prefs.getString(_keyGender) ?? '',
      image: prefs.getString(_keyImage) ?? '',
      phone: prefs.getString(_keyPhone) ?? '',
      age: prefs.getInt(_keyAge) ?? 0,
      city: prefs.getString(_keyCity) ?? '',
      country: prefs.getString(_keyCountry) ?? '',
      company: prefs.getString(_keyCompany) ?? '',
      jobTitle: prefs.getString(_keyJobTitle) ?? '',
      university: prefs.getString(_keyUniversity) ?? '',
      token: prefs.getString(_keyToken) ?? '',
    );
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
    await prefs.remove(_keyId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyGender);
    await prefs.remove(_keyImage);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyAge);
    await prefs.remove(_keyCity);
    await prefs.remove(_keyCountry);
    await prefs.remove(_keyCompany);
    await prefs.remove(_keyJobTitle);
    await prefs.remove(_keyUniversity);
    await prefs.remove(_keyToken);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }

  Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
  }
}

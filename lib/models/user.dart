class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String phone;
  final int age;
  final String city;
  final String country;
  final String company;
  final String jobTitle;
  final String university;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.image = '',
    this.phone = '',
    this.age = 0,
    this.city = '',
    this.country = '',
    this.company = '',
    this.jobTitle = '',
    this.university = '',
    this.token = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  User withToken(String newToken) => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    image: image,
    phone: phone,
    age: age,
    city: city,
    country: country,
    company: company,
    jobTitle: jobTitle,
    university: university,
    token: newToken,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> address = json['address'] is Map
        ? Map<String, dynamic>.from(json['address'])
        : {};
    final Map<String, dynamic> company = json['company'] is Map
        ? Map<String, dynamic>.from(json['company'])
        : {};

    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      city: address['city'] ?? '',
      country: address['country'] ?? '',
      company: company['name'] ?? '',
      jobTitle: company['title'] ?? '',
      university: json['university'] ?? '',
      token: json['accessToken'] ?? '',
    );
  }
}

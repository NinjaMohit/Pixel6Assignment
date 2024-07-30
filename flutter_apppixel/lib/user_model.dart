class User {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String country;
  final String imageUrl;
  final String maidenName;
  final int age;
  final String title;
  final String state;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.gender,
    required this.country,
    required this.imageUrl,
    required this.age,
    required this.title,
    required this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      age: json['age'] ?? 0,
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? 'Unknown',
      maidenName: json['maidenName'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      country: json['address']['country'] ?? 'Unknown',
      state: json["address"]['state'] ?? 'Unknown',
      title: json['company']['title'] ?? 'Unknown',
      imageUrl: json['image'] ?? 'https://pravatar.cc/150?u=${json['id'] ?? 0}',
    );
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
  final String apiUrl = "https://dummyjson.com/users";

  Future<List<User>> fetchUsers({int limit = 100, int skip = 0}) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?limit=$limit&skip=$skip'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> usersJson = data['users'];
        return usersJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:flutter/material.dart';
import 'user_model.dart';
import 'user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  List<User> _filteredUsers = [];
  int _page = 0;
  bool _isLoading = false;

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;

  void sortUsers(String criteria, bool ascending) {
    _filteredUsers.sort((a, b) {
      switch (criteria) {
        case 'name':
          return ascending
              ? a.firstName.compareTo(b.firstName)
              : b.firstName.compareTo(a.firstName);
        case 'age':
          return ascending ? a.age.compareTo(b.age) : b.age.compareTo(a.age);
        default:
          return 0;
      }
    });
    notifyListeners();
  }

  void filterUsers({String? gender, String? country}) {
    _filteredUsers = _users.where((user) {
      final matchesGender = gender == null || user.gender == gender;
      final matchesCountry = country == null || user.country == country;
      return matchesGender && matchesCountry;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<User> newUsers = await _userService.fetchUsers(skip: _page * 10);
      _users.addAll(newUsers);
      _filteredUsers = List.from(_users);
      _page++;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _users = [];
    _filteredUsers = [];
    _page = 0;
    fetchUsers();
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_apppixel/user_model.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider()..fetchUsers(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListPage();
}

class UserListPage extends State<UserList> {
  String? _selectedGender;
  String? _selectedCountry;
  String _sortCriteria = 'name';
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 195, 247),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.3)),
                child: DropdownButton<String>(
                  value: _selectedCountry,
                  hint: const Text(
                    'Country',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: ['USA', 'Canada', 'India'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      userProvider.filterUsers(
                          gender: _selectedGender, country: _selectedCountry);
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.3)),
                child: DropdownButton<String>(
                  value: _selectedGender,
                  hint: const Text('Gender'),
                  items: ['male', 'female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      userProvider.filterUsers(
                          gender: _selectedGender, country: _selectedCountry);
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.3)),
                child: DropdownButton<String>(
                  value: _sortCriteria,
                  items: ['name', 'age'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _sortCriteria = value!;
                      userProvider.sortUsers(_sortCriteria, _ascending);
                    });
                  },
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _ascending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _ascending = !_ascending;
                userProvider.sortUsers(_sortCriteria, _ascending);
              });
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: const Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "ID",
                              style: TextStyle(fontSize: 15),
                            ),
                            Icon(
                              Icons.arrow_upward,
                              size: 8,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              size: 8,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Image",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 23,
                        ),
                        Row(
                          children: [
                            Text("FullName", style: TextStyle(fontSize: 15)),
                            Icon(
                              Icons.arrow_upward,
                              size: 8,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              size: 8,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Text("Demography", style: TextStyle(fontSize: 15)),
                        SizedBox(
                          width: 27,
                        ),
                        Text("Designation", style: TextStyle(fontSize: 15)),
                        SizedBox(
                          width: 60,
                        ),
                        Text("Location", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black45,
                  height: 0.5,
                  width: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black45,
                      thickness: 1,
                    ),
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      User user = provider.users[index];

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                            height: 74,
                            width: 900,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 40,
                                        child: Text(
                                          "${user.id}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        width: 46,
                                        child: CircleAvatar(
                                          radius: 48, // Image radius
                                          backgroundImage:
                                              NetworkImage(user.imageUrl),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Text("${user.firstName} ",
                                                    style: const TextStyle(
                                                        fontSize: 15)),
                                                Text("${user.maidenName} ",
                                                    style: const TextStyle(
                                                        fontSize: 15)),
                                                Text(user.lastName,
                                                    style: const TextStyle(
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          ),
                                          Text(
                                              user.gender == "female"
                                                  ? 'F/'
                                                  : "M/",
                                              style: const TextStyle(
                                                  fontSize: 15)),
                                          Text("${user.age}",
                                              style: const TextStyle(
                                                  fontSize: 15)),
                                          const SizedBox(
                                            width: 82,
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: Text(user.title,
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Row(
                                              children: [
                                                Text("${user.state},",
                                                    style: const TextStyle(
                                                        fontSize: 15)),
                                                Text(" ${user.country}",
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class User {
  final int id;
  final String name;
  final String email;
  final String city;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      city: json['address']['city'],
    );
  }
}

void main() => runApp(
  const MaterialApp(home: UsersPage(), debugShowCheckedModeBanner: false),
);

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final dio = Dio();
  List<User> users = [];
  bool isLoading = true;
  String? error;


  Future<void> getUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await dio.get(
        "https://jsonplaceholder.typicode.com/users",
      );
      final List rawData = response.data;

      setState(() {
        users = rawData.map((e) => User.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = "Не удалось загрузить данные";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF8F9FA),
      appBar: AppBar(
        title:  Text(
          'Foydalanuvchilar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon:  Icon(Icons.refresh, color: Colors.blueAccent),
            onPressed: getUsers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }


  Widget _buildBody() {
    if (isLoading) {
      return  Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    if (error != null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center));
    }

    return ListView.builder(
      padding:  EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 0,
          margin:  EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: Text(
                user.name[0],
                style:  TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name,
              style:  TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${user.email}\n📍 ${user.city}"),
            isThreeLine: true,
            trailing:  Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_projects/auth/auth_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Profile Page"),
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}

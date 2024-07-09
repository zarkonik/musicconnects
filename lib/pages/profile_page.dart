import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/services/auth/auth_service.dart';
import 'package:flutter_projects/services/auth/login_or_register.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = AuthService();

  FirebaseStorage _storage = FirebaseStorage.instance;

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    downloadProfilePicture();
  }

  void logout(BuildContext context) {
    final _auth = AuthService();
    _auth.signOut();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()));
  }

  void downloadProfilePicture() async {
    final currentUser = _auth.getCurrentuser();
    Reference storageRef =
        _storage.ref().child('user_images').child('${currentUser!.uid}.jpg');

    profileImageUrl = await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Profile Page"),
        ),
        actions: [
          IconButton(
              onPressed: () => logout(context), icon: const Icon(Icons.logout))
        ],
      ),
      body: profileImageUrl != null
          ? Image(
              image: NetworkImage(profileImageUrl!),
              width: double.infinity,
              height: screenHeight / 2 + 100,
              fit: BoxFit.cover,
            )
          : Text("No image"),
    );
  }
}

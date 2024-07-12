import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/services/auth/auth_service.dart';
import 'package:flutter_projects/services/auth/login_or_register.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = AuthService();

  File? profilnaSlika;

  FirebaseStorage _storage = FirebaseStorage.instance;

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
  }

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    downloadProfilePicture();
  }*/

  void logout(BuildContext context) {
    final _auth = AuthService();
    _auth.signOut();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()));
  }

  void downloadProfilePicture() async {
    final _auth = AuthService();
    final _storage = FirebaseStorage.instance;

    final currentUser = _auth.getCurrentuser();
    if (currentUser == null) {
      print('No user currently logged in.');
      return;
    }

    Reference storageRef =
        _storage.ref().child('user_images').child('${currentUser.uid}.jpg');

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDocDir.path, 'images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final filePath = path.join(imagesDir.path, '${currentUser.email}.jpg');
      final file = File(filePath);

      profileImageUrl = await storageRef.getDownloadURL();
      final response = await http.get(Uri.parse(profileImageUrl!));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        print('Image downloaded and saved to $filePath');
      } else {
        print('Error in download: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
      body: Column(
        children: [
          profileImageUrl != null
              ? Image(
                  image: NetworkImage(profileImageUrl!),
                  width: double.infinity,
                  height: screenHeight / 2 + 100,
                  fit: BoxFit.cover,
                )
              : Text("No image"),
          IconButton(
              onPressed: downloadProfilePicture,
              icon: const Icon(Icons.download)),
        ],
      ),
    );
  }
}

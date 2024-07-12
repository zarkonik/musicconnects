import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/services/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class PickProfileImage extends StatefulWidget {
  const PickProfileImage({super.key});

  @override
  State<PickProfileImage> createState() => _PickProfileImageState();
}

class _PickProfileImageState extends State<PickProfileImage> {
  final _auth = AuthService();
  File? _pickedImageFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  Future<void> storeImage() async {
    final currentUser = _auth.getCurrentuser();
    Reference storageRef =
        _storage.ref().child('user_images').child('${currentUser!.uid}.jpg');
    await storageRef.putFile(_pickedImageFile!);
    final imageUrl = await storageRef.getDownloadURL();
  }

  void goToMainPage() async {
    await storeImage(); //ovde se ceka dok se slika ne uploaduje
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(child: Text('Select Image')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pickedImageFile != null
                ? Image(
                    image: FileImage(_pickedImageFile!),
                    width: double.infinity,
                    height: screenHeight / 2 + 100,
                    fit: BoxFit.cover,
                  )
                : Text("No image selected"),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text(
                'Add Image 123',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            GestureDetector(
              onTap: goToMainPage,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

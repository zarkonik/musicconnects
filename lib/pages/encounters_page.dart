import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/services/auth/auth_service.dart';
import 'package:swipable_stack/swipable_stack.dart';

class Encounters extends StatefulWidget {
  const Encounters({super.key});

  @override
  State<Encounters> createState() => _EncountersState();
}

class _EncountersState extends State<Encounters> {
  var currentIndex = 0;
  String profileImageUrl = "";
  final _auth = AuthService();
  final _storage = FirebaseStorage.instance;
  User? currentUser;
  List<String> imageUrlList = [];
  bool isLoading = true; // Added to handle loading state

  @override
  void initState() {
    super.initState();
    getCurrentuserFromFirestore();
    getAllUsers();
  }

  void getCurrentuserFromFirestore() async {
    if (profileImageUrl == "") {
      currentUser = _auth.getCurrentuser();
      if (currentUser != null) {
        Reference storageRef = _storage
            .ref()
            .child('user_images')
            .child('${currentUser!.uid}.jpg');
        try {
          final profilna = await storageRef.getDownloadURL();
          setState(() {
            profileImageUrl = profilna;
          });
        } catch (e) {
          print('Error fetching profile image: $e');
        }
      }
    }
  }

  void getAllUsers() async {
    List<Map<String, dynamic>> users = await _auth.getAllUsers();
    print('Fetched users: ${users.length}'); // Debug print

    if (users.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    Reference storageRef;
    String imageUrl = "";
    List<String> tempUrls = [];

    for (var user in users) {
      print('Fetching image for user: ${user['uid']}'); // Debug print
      storageRef =
          _storage.ref().child('user_images').child('${user['uid']}.jpg');
      try {
        imageUrl = await storageRef.getDownloadURL();
        print('Fetched image URL: $imageUrl'); // Debug print
        tempUrls.add(imageUrl);
      } catch (e) {
        print('Error fetching image URL for user ${user['uid']}: $e');
      }
    }

    setState(() {
      imageUrlList = tempUrls;
      isLoading = false; // Update loading state
    });

    if (imageUrlList.isEmpty) {
      print('No image URLs were added to the list.'); // Debug print
    } else {
      print('Total images fetched: ${imageUrlList.length}'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoading) // Show loading indicator if still loading
            Center(child: CircularProgressIndicator())
          else if (imageUrlList.isNotEmpty)
            SwipableStack(
              itemCount: imageUrlList.length,
              builder: (context, properties) {
                String imageUrl = imageUrlList[properties.index];
                print('Displaying image: $imageUrl'); // Debug print

                return ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Transform.scale(
                    scaleX: 0.95,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
              onSwipeCompleted: (index, direction) {
                print('Swiped $direction');
              },
            )
          else
            Center(child: Text('No images to display')), // Handle empty state
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.close),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.heart_broken),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: getCurrentuserFromFirestore,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

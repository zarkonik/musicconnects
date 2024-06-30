import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/auth/auth_gate.dart';
import 'package:flutter_projects/auth/login_or_register.dart';
import 'package:flutter_projects/firebase_options.dart';

import 'package:flutter_projects/pages/login_page.dart';
import 'package:flutter_projects/pages/register_page.dart';
import 'package:swipable_stack/swipable_stack.dart';

import 'pages/chat_page.dart';
import 'pages/likes_page.dart';
import 'pages/nearby.dart';
import 'pages/encounters_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var currentIndex = 0;

  final screens = [
    LoginPage(),
    Nearby(),
    Encounters(),
    Likes(),
    Chat(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(child: Text('MusicConnects')),
      ),
      backgroundColor: Colors.white,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            label: 'Login',
            icon: Icon(Icons.login),
          ),
          BottomNavigationBarItem(
            label: 'Nearby',
            icon: Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: "Encounters",
            icon: Icon(Icons.style),
          ),
          BottomNavigationBarItem(
            label: "Likes",
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

class ImageSwiper extends StatelessWidget {
  final List<String> _images = [
    'images/borealis.jpg',
    'images/DayGZax.jpg',
    // Add more image URLs or paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Image Swiper')),
      ),
      body: Center(
        child: SwipableStack(
          itemCount: _images.length,
          builder: (context, properties) {
            return Image.asset(
              _images[properties.index],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            );
          },
          onSwipeCompleted: (index, direction) {
            print('Swiped $direction');
          },
        ),
      ),
    );
  }
}

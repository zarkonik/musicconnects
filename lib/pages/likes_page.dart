import 'package:flutter/material.dart';

class Likes extends StatefulWidget {
  const Likes({super.key});

  @override
  State<Likes> createState() => _NearbyState();
}

class _NearbyState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Likes Page"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Nearby Page"),
        ),
      ),
    );
  }
}

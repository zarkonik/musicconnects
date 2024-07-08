import 'package:flutter/material.dart';

class PickProfileImage extends StatelessWidget {
  const PickProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker."),
      ),
    );
  }
}

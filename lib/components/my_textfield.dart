import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obsureText;
  final TextEditingController controller;
  const MyTextfield(
      {super.key,
      required this.hintText,
      required this.obsureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            hintText: hintText),
      ),
    );
  }
}

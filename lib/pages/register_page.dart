import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_projects/auth/auth_service.dart';
import 'package:flutter_projects/components/my_button.dart';
import 'package:flutter_projects/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
            _emailController.text, _pwController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Passwords do not match"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Create an account for you..",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
              const SizedBox(
                height: 50,
              ),
              MyTextfield(
                hintText: "Email",
                obsureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(
                hintText: "Password",
                obsureText: true,
                controller: _pwController,
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextfield(
                hintText: "Confirm password",
                obsureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an accont? "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login Now!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

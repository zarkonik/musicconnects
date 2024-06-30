import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_projects/auth/auth_service.dart';
import 'package:flutter_projects/components/my_button.dart';
import 'package:flutter_projects/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pwController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
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
                "Welcome back..",
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
              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register now!",
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

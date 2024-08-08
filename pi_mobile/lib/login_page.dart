import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_mobile/LoginTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.message.toString());
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAFAFA),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).canvasColor
          : Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginBackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(""),
            ),
            //intro text
            Stack(
              children: <Widget>[
                // Stroked text as border.
                Text(
                  'MobileMaster',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Theme.of(context).primaryColor,
                  ),
                ),
                // Solid text as fill.
                const Text(
                  'MobileMaster',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //email input box
            LoginTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              max: 1,
            ),
            const SizedBox(height: 10),
            //password input box
            LoginTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              max: 1,
            ),
            const SizedBox(height: 30),
            //sign in button
            GestureDetector(
              onTap: signUserIn,
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
          ],
        ),
      ),
    );
  }
}

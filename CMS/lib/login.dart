import 'package:flutter/material.dart';
import 'package:cms_apps_mobile/widgets/login_field.dart';
import 'package:cms_apps_mobile/widgets/submit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Text(
                    'MobileMaster',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Color.fromRGBO(136, 240, 100, 1),
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0,5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:15),
                  LoginField(hintText: 'Email', controller: emailController),
                  const SizedBox(height:15),
                  LoginField(hintText: 'Password', controller: passwordController),
                  const SizedBox(height:15),
                  SubmitButton(onTap: signUserIn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
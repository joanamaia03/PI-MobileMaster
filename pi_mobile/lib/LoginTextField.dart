import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int max;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        minLines: max,
        maxLines: max,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.black54,
          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}

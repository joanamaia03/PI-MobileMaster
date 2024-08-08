import 'package:flutter/material.dart';

class LoginField extends StatelessWidget{
  final String hintText;
  final TextEditingController controller;
  const LoginField({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context){
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child:Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(27),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(136, 240, 100, 1),
                  width:3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(136, 240, 100, 1),
                  width:3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
              )
          ),
        ),
      ),
    );
  }
}
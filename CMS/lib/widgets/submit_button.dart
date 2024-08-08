import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onTap;
  const SubmitButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(395, 55), backgroundColor: const Color.fromRGBO(136, 240, 100, 1),
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color.fromRGBO(0,0,0,1),
              blurRadius: 15,
              offset: Offset(0,5),
            ),
          ],
        ),
      ),
    );
  }
}
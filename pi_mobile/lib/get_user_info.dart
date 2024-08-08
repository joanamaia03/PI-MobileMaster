import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserInfo extends StatelessWidget {
  final String uid;
  final String info;
  final FontWeight bold;
  final double size;
  final Color color;

  const GetUserInfo({
    super.key,
    required this.uid,
    required this.info,
    required this.bold,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: TextStyle(
              fontWeight: bold,
              fontSize: size,
              color: color,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data[info],
            style: TextStyle(
              fontWeight: bold,
              fontSize: size,
              color: color,
            ),
          );
        }
        return Text(
          'loading...',
          style: TextStyle(
            fontWeight: bold,
            fontSize: size,
            color: color,
          ),
        );
      }),
    );
  }
}

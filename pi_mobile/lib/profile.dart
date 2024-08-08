import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'get_user_info.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 35,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 80,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GetUserInfo(
                  uid: user.uid,
                  info: 'name',
                  bold: FontWeight.bold,
                  size: 25,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    GetUserInfo(
                      uid: user.uid,
                      info: 'field',
                      bold: FontWeight.bold,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

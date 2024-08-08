import 'package:cms_apps_mobile/models/Block.dart';
import 'package:flutter/material.dart';

class SubmitButton extends Block {
  @override convert (double width) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
          onPressed: () {},
          child: Text("Submit")
      ),
    );
  }
}
import 'dart:typed_data';

import 'package:cms_apps_mobile/models/Block.dart';
import 'package:flutter/material.dart';

class ImageBox extends Block {
  Uint8List imageData;
  double _height = 100;

  ImageBox(this.imageData);

  Uint8List getImageData() => imageData;
  double getHeight() => _height;

  void setHeight(double height) => _height = height;

  @override convert(double width) {
    return Container(
      width: width,
      height: _height,
      child: Image.memory(imageData, fit: BoxFit.fill)
    );
  }

  @override getProperties() {
    List<Widget> properties = [];

    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Height',
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        initialValue: _height.toString(),
        onChanged: (value) => setHeight(double.parse(value)),
      )
    ));

    return properties;
  }
}
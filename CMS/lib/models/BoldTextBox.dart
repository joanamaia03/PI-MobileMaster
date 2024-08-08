import 'package:cms_apps_mobile/models/Block.dart';
import 'package:flutter/material.dart';

class BoldTextBox extends Block {
  String _value = '';

  String getValue() => _value;

  void setValue(String newVal) => _value = newVal;

  @override convert(double width) {
    return Container(
      width: width * x_ratio /5,
      height: 50 * y_ratio,
      child: Text(
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.values.firstWhere((element) =>
          element.name == align),
          _value
      ),
    );
  }

  @override getProperties() {
    List<Widget> properties = [];
    properties.add(SizedBox(width: 200,
        height: 200,
        child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Text', // Adicionando labelText
              labelStyle: TextStyle(color: Colors.grey), // Adicionando cor à label
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            initialValue: _value, onChanged: (text) { setValue(text);})));

    properties.add(
        DropdownButton(
            hint: Text(alignHint),
            items: alignTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              alignHint = newValue!;
              setAlign(newValue);
            }));
    return properties;
  }
}
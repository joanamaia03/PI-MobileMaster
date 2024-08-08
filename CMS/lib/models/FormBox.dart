import 'package:cms_apps_mobile/models/Block.dart';
import 'package:flutter/material.dart';

class FormBox extends Block {
  String _value = '';
  String _hint = '';

  String getValue() => _value;
  String getHint() => _hint;

  void setValue(String newVal) => _value = newVal;
  void setHint(String newHint) => _hint = newHint;

  @override convert(double width) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: Text(
            textAlign: TextAlign.values.firstWhere((element) => element.name == align),
            _value
          )
        ),
        SizedBox(
          width: width,
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              hintText: _hint
            ),
            textAlign: TextAlign.values.firstWhere((element) => element.name == align),
          ),
        )
      ],
    );
  }

  @override getProperties() {
    List<Widget> properties = [];
    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Title',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        initialValue: _value,
        onChanged: (text) => setValue(text)
      ),
    ));
    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        initialValue: _hint,
        onChanged: (text) => setHint(text),
      ),
    ));
    properties.add(DropdownButton(
        items: alignTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          alignHint = newValue!;
          setAlign(newValue);
        }
    ));
    return properties;
  }
}
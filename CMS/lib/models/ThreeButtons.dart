import 'package:cms_apps_mobile/models/Block.dart';
import 'package:flutter/material.dart';

class ThreeButtons extends Block {
  String _value = '';
  String _optionA = '';
  String _optionB = '';
  String _optionC = '';
  String _selected = '';

  String getValue() => _value;
  String getA() => _optionA;
  String getB() => _optionB;
  String getC() => _optionC;
  String getSelected() => _selected;

  void setValue(String newVal) => _value = newVal;
  void setA(String newA) => _optionA = newA;
  void setB(String newB) => _optionB = newB;
  void setC(String newC) => _optionC = newC;
  void setSelected(String newSelected) => _selected = newSelected;

  @override convert(double width) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: 100,
          child: Text(
              textAlign: TextAlign.values.firstWhere((element) => element.name == align),
              _value
          ),
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListTile(
                  title: Text(_optionA),
                  leading: Radio<String>(
                    value: _optionA,
                    groupValue: _selected,
                    onChanged: (String? value) {
                      //setSelected(value!);
                    },
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                    title: Text(_optionB),
                    leading: Radio<String>(
                      value: _optionB,
                      groupValue: _selected,
                      onChanged: (String? value) {
                        //setSelected(value!);
                      },
                    )
                ),
              ),
              Flexible(
                child: ListTile(
                  title: Text(_optionC),
                  leading: Radio<String>(
                    value: _optionC,
                    groupValue: _selected,
                    onChanged: (String? value) {
                      //setSelected(value!);
                    },
                  ),
                )
              )
            ],
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
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: 'Title',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )
        ),
        initialValue: _value,
        onChanged: (text) => setValue(text),
      ),
    ));

    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: 'Option A',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )
        ),
        initialValue: _optionA,
        onChanged: (text) => setA(text),
      ),
    ));

    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: 'Option B',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )
        ),
        initialValue: _optionB,
        onChanged: (text) => setB(text),
      ),
    ));

    properties.add(SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: 'Option C',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )
        ),
        initialValue: _optionC,
        onChanged: (text) => setC(text),
      ),
    ));

    return properties;
  }
}
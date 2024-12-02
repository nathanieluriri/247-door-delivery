import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String?> onChanged;

  CustomDropdown({required this.items, required this.onChanged});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,

      focusColor: Colors.white,
      hint: Text('Select an option'),
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
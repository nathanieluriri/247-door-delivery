import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  final Color inputColor;
  final String helper;
  final String hint;
  final String label;
  final TextEditingController controller;

  const TextInput(
      {super.key,
      required this.inputColor,
      required this.helper,
      required this.hint,
      required this.label,
      required this.controller});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 400, minWidth: 200, maxHeight: 160, minHeight: 140),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: widget.inputColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
                child: TextFormField(
              controller: widget.controller,
                  inputFormatters: widget.label == 'Email *'
                      ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                      : widget.label == 'tele no *'
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
              keyboardType: widget.label == 'Email *'
                  ? TextInputType.emailAddress
                  : widget.label == 'tele no *'
                      ? TextInputType.phone
                      : TextInputType.text,
              cursorColor: Color(0xFF000000),
              decoration: InputDecoration(
                  focusColor: Color(0xFF000000),
                  floatingLabelStyle: TextStyle(
                      color: Color(0xAA000000), fontWeight: FontWeight.bold),
                  labelText: "${widget.label}",
                  hintText: '${widget.hint}',
                  focusedBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  helperText: "${widget.helper}",
                  hoverColor: widget.inputColor,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            )),
          )),
    );
  }
}

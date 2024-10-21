import 'package:flutter/material.dart';

import 'TextInput.dart';

class TextFields extends StatefulWidget {
  final double screenWidth;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailAddressController;

  const TextFields(
      {super.key,
      required this.screenWidth,
      required this.nameController,
      required this.phoneNumberController,
      required this.emailAddressController});

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1300),
      child: widget.screenWidth < 1240
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInput(
                  inputColor: const Color(0xAAFFFBF1),
                  label: "Name *",
                  helper: "Enter your full name",
                  hint: " ",
                  controller: widget.nameController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextInput(
                  inputColor: const Color(0xFFFFE5FC),
                  label: "tele no *",
                  helper: "Enter your phone number",
                  hint: " ",
                  controller: widget.phoneNumberController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextInput(
                  inputColor: const Color(0xAAFBDAD3),
                  label: "Email *",
                  helper: "Enter your email Address",
                  hint: " ",
                  controller: widget.emailAddressController,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextInput(
                  inputColor: const Color(0xAAFFFBF1),
                  label: "Name *",
                  helper: "Enter your full name",
                  hint: " ",
                  controller: widget.nameController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextInput(
                  inputColor: const Color(0xFFFFE5FC),
                  label: "tele no *",
                  helper: "Enter your phone number",
                  hint: "",
                  controller: widget.phoneNumberController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextInput(
                  inputColor: const Color(0xAAFBDAD3),
                  label: "Email *",
                  helper: "Enter your email Address",
                  hint: "",
                  controller: widget.emailAddressController,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
    );
  }
}

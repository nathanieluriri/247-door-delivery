import 'package:flutter/material.dart';

import 'Textfields.dart';
import 'checkbox.dart';

class CheckBoxLayout extends StatefulWidget {
  final double screenWidth;
  final VoidCallback onchanged;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  const CheckBoxLayout({super.key, required this.screenWidth, required this.onchanged, required this.nameController, required this.phoneNumberController, required this.emailController});

  @override
  State<CheckBoxLayout> createState() => _CheckBoxLayoutState();
}

class _CheckBoxLayoutState extends State<CheckBoxLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.nameController.addListener(() {
      setState(() {});
    });
    widget.phoneNumberController.addListener(() {
      setState(() {});
    });
    widget.emailController.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1300),
      child: widget.screenWidth < 600
          ?  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFields(screenWidth: widget.screenWidth, nameController: widget.nameController, phoneNumberController: widget.phoneNumberController, emailAddressController: widget.emailController,),
               const SizedBox(
                  height: 30,
                ),
                 CheckBox(onChaged: widget.onchanged,),

              ],
            )
          :  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFields(screenWidth: widget.screenWidth, nameController: widget.nameController, phoneNumberController: widget.phoneNumberController, emailAddressController: widget.emailController,),
                const SizedBox(
                  height: 30,
                ),
                 CheckBox(onChaged: widget.onchanged,),


              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class CheckBox extends StatefulWidget {
  final VoidCallback onChaged;
  final String text;

  const CheckBox({super.key, required this.onChaged, this.text="Save my details to speed up my next booking process"});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  var box = Hive.box("CustomerInfo");
  late bool isChecked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = box.get("isChecked") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: isChecked,
              activeColor: Colors.blue,
              onChanged: (bool? value) {
                isChecked ? box.put("isChecked", false) : widget.onChaged();
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
             SizedBox(
              width: 6,
            ),
            Flexible(
                child: Text(
              widget.text,
              style:
                  GoogleFonts.poppins(color: Color(0xFF2C2C2E), fontSize: 12),
              softWrap: true,
            )),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DateWidget extends StatefulWidget {
  final String hint;
  final TextEditingController dateTimeController;
  final DateTime lastDate;
  const DateWidget(
      {super.key,
      required this.hint,
      required this.dateTimeController,
      required this.lastDate});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  DateTime? _pickedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.dateTimeController,
        showCursor: false,
        mouseCursor: SystemMouseCursors.click,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.hint,
          fillColor: Color(0x32E3E3E3),
          filled: true,
          prefixIcon: IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: selectDate,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: widget.dateTimeController.text.isEmpty
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: selectDate,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      widget.dateTimeController.text = "";
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
        ),
        onTap: selectDate,
        readOnly: true,
      ),
    );
  }

  Future<void> selectDate() async {
    _pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: widget.lastDate);
    if (_pickedDate != null) {
      setState(() {
        widget.dateTimeController.text = _pickedDate.toString().split(" ")[0];
      });
    }
  }
}

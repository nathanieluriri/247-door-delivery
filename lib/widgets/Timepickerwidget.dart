import 'package:flutter/material.dart';
class TimeWidget extends StatefulWidget {
  final String hint;
  final TextEditingController dateTimeController;

  const TimeWidget({super.key, required this.hint, required this.dateTimeController,});

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  TimeOfDay? _pickedTime;


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
            icon: Icon(Icons.timelapse),
            onPressed: selectTime,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: widget.dateTimeController.text.isEmpty
              ? IconButton(
            icon: Icon(Icons.add),
            onPressed: selectTime,
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
        onTap: selectTime,
        readOnly: true,
      ),
    );
  }
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    // Use MediaQuery to access MaterialLocalizations for formatting
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }

  Future<void> selectTime() async {
    _pickedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (_pickedTime != null) {
      setState(() {
        widget.dateTimeController.text = formatTimeOfDay(_pickedTime!);

      });
    }
  }
}





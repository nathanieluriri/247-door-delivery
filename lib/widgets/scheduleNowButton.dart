import 'package:flutter/material.dart';

class ScheduleNowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool active;

  const ScheduleNowButton(
      {super.key, required this.onPressed, required this.active});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: active ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.red.withOpacity(0.6) : Colors.grey,
        minimumSize: (screenWidth < 576)? Size(100, 50):Size(200, 50), // Width and height
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
          ),
          // Space between icon and text
          Text(
            'Schedule Now ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.timer, // Lock icon to resemble a secure payment
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }
}

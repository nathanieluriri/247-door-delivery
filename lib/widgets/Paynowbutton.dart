import 'package:flutter/material.dart';

class PayNowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool active;

  const PayNowButton({Key? key, required this.onPressed, required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: active? onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor:active? Colors.blue[300]: Colors.grey, // Stripe-like blue color
        minimumSize: Size(200, 50), // Width and height
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [

           SizedBox(width: 6,),
           // Space between icon and text
          Text(
            'Pay ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.lock, // Lock icon to resemble a secure payment
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }
}


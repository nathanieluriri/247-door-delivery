import 'package:_247_door_delivery/pages/Pickuppage.dart';
import 'package:flutter/material.dart';

class NextButton extends StatefulWidget {
  final bool isactive;

  const NextButton({super.key, required this.isactive});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: widget.isactive
              ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickupLocationScreen()));
                }
              : (){},
          splashColor: Colors.white30,
          color: widget.isactive ? Colors.black : Colors.grey[300],
          clipBehavior: Clip.hardEdge,
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

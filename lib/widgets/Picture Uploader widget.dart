import 'dart:async';

import 'package:_247_door_delivery/CameraApp.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../ImagePicker.dart';

class PictureUploader extends StatefulWidget {
  final String hint;
  final TextEditingController photocontroller;
  final VoidCallback clearF;

  const PictureUploader({
    super.key,
    required this.hint, required this.photocontroller, required this.clearF
  });

  @override
  State<PictureUploader> createState() => _PictureUploaderState();
}


class _PictureUploaderState extends State<PictureUploader> {
  DateTime? _pickedDate;
  bool active = true;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
      });
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var box = Hive.box("CameraDetails");
    var condition = box.get("ImageId");
    if (condition == "null"||condition==null) {

      setState(() {
        active = true;
      });
    } else {
      setState(() {
        active = false;

      });
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        showCursor: false,
        controller: widget.photocontroller,
        mouseCursor: SystemMouseCursors.click,
        decoration: InputDecoration(
          hintText: active ? widget.hint : "Photo Uploaded",
          labelText: active ? widget.hint : "Photo Uploaded",
          fillColor:
              active ? Color(0x32E3E3E3) : Colors.greenAccent.withOpacity(0.29),
          filled: true,
          prefixIcon: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              if (box.get("shouldRedirect")!=true){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyWebImagePickerApp()),
                );
              }
            },
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: active
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (box.get("shouldRedirect")!=true){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyWebImagePickerApp()),
                      );
                    }
                  },
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      widget.clearF();
                      box.clear();

                    });
                  },
                  icon: Icon(Icons.clear),
                ),
        ),
        onTap: () {
          if (box.get("shouldRedirect")!=true){
            Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyWebImagePickerApp()),
                );

          }
          setState(() {

          });

        },
        onChanged: (string){
          setState(() {
            print(string);


          });

    },
        onTapAlwaysCalled: true,

        readOnly: true,
      ),
    );
  }
}


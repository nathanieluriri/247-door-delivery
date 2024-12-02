

import 'package:_247_door_delivery/pages/Addressinfo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class AddressUploader extends StatefulWidget {
  final VoidCallback onTap;

  const AddressUploader({super.key, required this.onTap, });

  @override
  State<AddressUploader> createState() => _AddressUploaderState();
}

class _AddressUploaderState extends State<AddressUploader> {
  String mydata = "";
  var box = Hive.box("AddressDetails");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("mydata $mydata");

    return  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: (mydata != "submitted")
                ? ListTile(
                    title: const Text("Enter Descriptive Address Details"),
                    leading: const Icon(Icons.location_on),
                    tileColor: Colors.grey.withOpacity(0.09),
                    shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(5)),
                    onTap: () async {
                      mydata = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressDetails()));
                      if (mydata != null) {

                        print("mydataee $mydata");
                        var box = Hive.box("AddressDetails");
                        box.put("submitted", true);
                        widget.onTap();
                        setState(() {

                        });

                      }
                    },
                  )
                : ListTile(
                    tileColor: Colors.blue.withOpacity(0.09),
                    title: MaterialButton(
                        onPressed: null, child: Text("Address Submitted")),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    leading: const Icon(Icons.location_on),
                    trailing: Icon(
                      Icons.check_circle,
                      color: Colors.blue.shade300,
                    ),
                    subtitle: MaterialButton(
                      onPressed: () {
                        var box = Hive.box("AddressDetails");
                        box.put("submitted", false);
                        mydata="";
                        setState(() {

                        });
                        widget.onTap();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressDetails()));
                      },
                      child: Text("Edit Address "),
                    ),
                  ),
          ),

    );
  }
}

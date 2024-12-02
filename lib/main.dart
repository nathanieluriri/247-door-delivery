import 'package:_247_door_delivery/pages/Homepage.dart';
import 'package:_247_door_delivery/pages/Pickuppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  await Hive.initFlutter();

  var box= await Hive.openBox("CustomerInfo");
  var box2 = await Hive.openBox("PickupDetails");
  var box3 = await Hive.openBox("DropoffDetails");
  var box4 = await Hive.openBox("CameraDetails");
  var box5 = await Hive.openBox("AddressDetails");
  box5.put("submitted",false);
  box4.clear();



  if (box.get("isChecked") != null) {
    if (box.get("isChecked")) {
      if ((box.get("name").toString().length >= 4) &&
          (box.get("phoneNumber").toString().isNotEmpty) &&
          (box.get("name").toString().isNotEmpty) &&
          (box.get("email").toString().isNotEmpty)) {

        runApp(


            const MaterialApp(
              home: Scaffold(

                body: PickupLocationScreen(),
              ),
            ));
      }
    }
  }
  else{
    runApp(


        const MaterialApp(
          home: Scaffold(

            body: HomePage(),
          ),
        ));
  }

}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageUi();
  }
}

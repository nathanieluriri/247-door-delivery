import 'package:_247_door_delivery/pages/Pickuppage.dart';
import 'package:_247_door_delivery/widgets/CheckBoxLayout.dart';
import 'package:_247_door_delivery/widgets/NextButton.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePageUi extends StatefulWidget {
  const HomePageUi({super.key});

  @override
  State<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi> {
  bool isChecked = false;
  bool isActive = false;
  var box = Hive.box("CustomerInfo");

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (box.get("isChecked") != null) {
        if (box.get("isChecked")) {
          if ((box.get("name").toString().length >= 4) &&
              (box.get("phoneNumber").toString().isNotEmpty) &&
              (box.get("name").toString().isNotEmpty) &&
              (box.get("email").toString().isNotEmpty)) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PickupLocationScreen()),
            );
          }
        }
      }
    });
    nameController.addListener(() {
      box.put("name", nameController.text.toLowerCase());

      setState(() {});
    });
    phoneNumberController.addListener(() {
      box.put("phoneNumber", phoneNumberController.text);

      setState(() {});
    });
    emailAddressController.addListener(() {
      box.put("email", emailAddressController.text.toLowerCase());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setActive();
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CheckBoxLayout(
                screenWidth: screenWidth,
                onchanged: () {
                  box.put("isChecked", true);
                  Map<String, String> CustomerData = {
                    'name': nameController.text,
                    'phoneNumber': phoneNumberController.text,
                    'email': emailAddressController.text
                  };
                  box.putAll(CustomerData);
                },
                nameController: nameController,
                phoneNumberController: phoneNumberController,
                emailController: emailAddressController,
              ),
              NextButton(
                isactive: isActive,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Regular expression for a valid email address
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);

    // Return true if the email matches the pattern
    return regExp.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Regular expression for a valid phone number (allows numbers with optional country code, and spaces or dashes)
    String phonePattern = r'^\+?[0-9]{10,15}$';
    RegExp regExp = RegExp(phonePattern);

    // Return true if the phone number matches the pattern
    return regExp.hasMatch(phoneNumber);
  }

  void setActive() {
    if (isValidEmail(emailAddressController.text) &&
        isValidPhoneNumber(phoneNumberController.text)) {
      setState(() {
        isActive = true;
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
  }
}

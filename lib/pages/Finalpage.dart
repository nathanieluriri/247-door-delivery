import 'dart:async';

import 'package:_247_door_delivery/Apis/Distancecalculator.dart';
import 'package:_247_door_delivery/Db/Db.dart';
import 'package:_247_door_delivery/widgets/Timepickerwidget.dart';
import 'package:_247_door_delivery/widgets/scheduleNowButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Apis/Paymentlink.dart';
import '../widgets/Datepickerwidget.dart';
import '../widgets/Paynowbutton.dart';
import '../widgets/Picture Uploader widget.dart';

class FinalDetails extends StatefulWidget {
  const FinalDetails({super.key});

  @override
  State<FinalDetails> createState() => _FinalDetailsState();
}

class _FinalDetailsState extends State<FinalDetails> {
  final TextEditingController _PickupdateController = TextEditingController();
  final TextEditingController _DropoffdateController = TextEditingController();
  final TextEditingController _PickupTimeController = TextEditingController();
  final TextEditingController _DropoffTimeController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  bool active = false;
  var pickupbox = Hive.box("PickupDetails");
  var dropoffbox = Hive.box("DropoffDetails");
  var customerinfobox = Hive.box('CustomerInfo');
  final FirebaseDb db = FirebaseDb();
  double? Distance;
  bool? shouldRedirect;
  Timer? _timerforfinalPage;


  bool isDateALessThanB(String dateA, String dateB) {
    bool result = false;

    // Convert the string dates to DateTime objects
    DateTime? parsedDateA = DateTime.tryParse(dateB);
    DateTime? parsedDateB = DateTime.tryParse(dateA);

    // Check if the dates were parsed successfully
    if (parsedDateA == null || parsedDateB == null) {
      throw FormatException('Invalid date format. Please use "YYYY-MM-DD".');
    }

    // Return true if dateA is less than dateB, otherwise return false
    if (parsedDateA.isAtSameMomentAs(parsedDateB)) {
      result = false;
      print(result);
    } else if (parsedDateA.isBefore(parsedDateB)) {
      result = true;
    }
    return result;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timerforfinalPage?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerforfinalPage = Timer(const Duration(milliseconds: 500), (){
      dynamic box4 = Hive.box("CameraDetails");
      if (box4.get("shouldRedirect") ==true) {
        setState(() {

          shouldRedirect = box4.get("shouldRedirect");
          print("new shouldRedirect = $shouldRedirect");
        });
      }

      else{
        setState(() {

        });
      }

    });

    setDistance();

    _PickupdateController.addListener(() {
      setState(() {});
    });
    _PickupTimeController.addListener(() {
      setState(() {});
    });
    _DropoffdateController.addListener(() {
      clearDate();
      setState(() {});
    });
    _DropoffTimeController.addListener(() {
      setState(() {});
    });
    photoController.addListener((){
      setState(() {
        dynamic box4 = Hive.box("CameraDetails");
        setActive();
      });
    });
  }

  @override
  Widget build(BuildContext context) {



    setActive();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Enter Additional Information",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 18),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 PictureUploader(
                   clearF: (){
                     dynamic cbox = Hive.box("CameraDetails");
                     setState(() {
                       shouldRedirect = cbox.get("shouldRedirect");
                     });
                     _PickupdateController.clear();
                     _DropoffTimeController.clear();
                     _PickupTimeController.clear();
                     _DropoffdateController.clear();
                   },

                  hint: "Take A Picture Of The Package", photocontroller: photoController,
                ),
                DateWidget(
                  hint: 'Select a Pickup Date',
                  dateTimeController: _PickupdateController,
                  lastDate: _DropoffdateController.text.isNotEmpty
                      ? DateTime.tryParse(_DropoffdateController.text) ??
                          DateTime(2025)
                      : DateTime(2100),
                ),
                DateWidget(
                  hint: 'Select a Drop Date',
                  dateTimeController: _DropoffdateController,
                  lastDate: DateTime(2100),
                ),
                TimeWidget(
                  hint: "Select a Pick up Time",
                  dateTimeController: _PickupTimeController,
                ),
                TimeWidget(
                  hint: "Select a Drop Off Time",
                  dateTimeController: _DropoffTimeController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ScheduleNowButton(
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime threehourslater =
                              now.add(Duration(hours: 3));
                          String getCurrentTime = "${now.hour}:${now.minute}";

                          String currentDate =
                              "${now.year}-${now.month}-${now.day}";
                          String getLater =
                              "${threehourslater.hour}:${threehourslater.minute}";

                          _PickupdateController.text = currentDate;
                          _DropoffdateController.text = currentDate;

                          _PickupTimeController.text = getCurrentTime;
                          _DropoffTimeController.text = getLater;
                        },
                        active: true),
                    PayNowButton(
                      onPressed: () async {
                        String name = customerinfobox.get('name');
                        String phoneNumber = customerinfobox.get("phoneNumber");
                        String email = customerinfobox
                            .get("email")
                            .toString()
                            .toLowerCase();
                        Map<String, dynamic> pickUpDetails =
                            pickupbox.toMap().cast<String, dynamic>();

                        Map<String, dynamic> dropOffDetails =
                            dropoffbox.toMap().cast<String, dynamic>();
                        Map<String, dynamic> schedule = {
                          'pickUpTime': _PickupTimeController.text,
                          'pickUpDate': _PickupdateController.text,
                          'dropOffTime': _DropoffTimeController.text,
                          'dropOffDate': _DropoffdateController.text,
                        };
                        var cbox = Hive.box("CameraDetails");
                        db.addUser(
                            name: name.toLowerCase(),
                            phoneNumber: phoneNumber,
                            email: email.toLowerCase(),
                            pickUpDetails: pickUpDetails,
                            dropOffDetails: dropOffDetails,
                            schedule: schedule,
                            imageid: cbox.get("ImageId")
                        );

                        await LaunchUrl(distance: Distance);

                      },
                      active: active,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String percentageEncode(String input) {
    return Uri.encodeComponent(input);
  }

  Future<void> LaunchUrl({required double? distance}) async {
    if (distance != null) {
      String email = customerinfobox.get("email");
      String parsedEmail = percentageEncode(email);
      double deliveryDistance = distance;

      String currency = "gbp";
      String pickUpDetails = pickupbox.toMap()['mainText'].toString();
      String dropOffDetails = dropoffbox.toMap()['mainText'].toString();

      if (distance <= 12) {
        int deliveryPrice = 1500 + 500;

        String? paymentLink = await createPaymentLink(
            deliveryDistance,
            deliveryPrice,
            currency,
            pickUpDetails,
            dropOffDetails,
            _PickupdateController.text,
            _DropoffdateController.text,
            _DropoffTimeController.text,
            _DropoffTimeController.text);
        await launchUrl(Uri.parse('$paymentLink?prefilled_email=$parsedEmail'),
            webOnlyWindowName: '_blank');
      } else if (distance > 12) {
        double additional_distance = distance - 12;
        double calc = 175 * additional_distance;
        int deliveryPrice = 1500 + 500 + calc.toInt();
        String? paymentLink = await createPaymentLink(
            deliveryDistance,
            deliveryPrice,
            currency,
            pickUpDetails,
            dropOffDetails,
            _PickupdateController.text,
            _DropoffdateController.text,
            _DropoffTimeController.text,
            _DropoffTimeController.text);
        await launchUrl(Uri.parse('$paymentLink?prefilled_email=$parsedEmail'),
            webOnlyWindowName: '_blank');
      }
    }
  }

  void setActive() {
    print("shouldRedirect $shouldRedirect");
    if ((_PickupTimeController.text.isNotEmpty) &&
        (_PickupdateController.text.isNotEmpty) &&
        (_DropoffdateController.text.isNotEmpty) &&
        (_DropoffTimeController.text.isNotEmpty) &&
        (shouldRedirect ==true))  {
      setState(() {
        active = true;
      });
    } else {
      active = false;
    }
  }

  Future<void> showCustomDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Custom Dialog'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void setDistance() async {
    var pickupInfo = pickupbox.toMap();
    var dropOffInfo = dropoffbox.toMap();
    String originId = pickupInfo['placeId'];
    String destinationId = dropOffInfo['placeId'];
    double? distance = await getDistance(
        originPlaceId: originId, destinationPlaceId: destinationId);
    setState(() {
      Distance = distance;
    });
    print(Distance);
  }

  void clearDate() {
    if (_DropoffdateController.text.isNotEmpty &&
        _PickupdateController.text.isNotEmpty) {
      if (isDateALessThanB(
          _PickupdateController.text, _DropoffdateController.text)) {
        _PickupdateController.clear();
      }
    }
  }
}

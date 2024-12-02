import 'package:_247_door_delivery/widgets/DropDown.dart';
import 'package:_247_door_delivery/widgets/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  var box = await Hive.openBox("AddressDetails");
  runApp(MaterialApp(
    home: AddressDetails(),
  ));
}

String sanitizeInput(String input) {
  // Escape special characters to prevent injection
  return input
      .replaceAll('\$', '\\\$') // Escape dollar signs
      .replaceAll('\'', '\\\'') // Escape single quotes
      .replaceAll('\"', '\\\"') // Escape double quotes
      .replaceAll('\n', '\\n') // Escape new lines
      .replaceAll('\r', '\\r') // Escape carriage returns
      .replaceAll('`', '\\`'); // Escape backticks
}

class AddressDetails extends StatefulWidget {
  const AddressDetails({super.key});

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  TextEditingController streetName = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController houseNumber = TextEditingController();
  TextEditingController dropOffStreetName = TextEditingController();
  TextEditingController dropOffBuildingName = TextEditingController();
  TextEditingController dropOffHouseNumber = TextEditingController();
  bool activeSubmit = false;
  bool ischecked = false;
  dynamic box = Hive.box("AddressDetails");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (box.get("Pick Up Street Name").toString().isNotEmpty) {
      areAllInputsValid();
      streetName.text = box.get("Pick Up Street Name") ?? "";
    }
    if (box.get("Pick Up Building Name").toString().isNotEmpty) {
      areAllInputsValid();
      buildingName.text = box.get("Pick Up Building Name") ?? "";
    }
    if (box.get("Pick Up House Number").toString().isNotEmpty) {
      areAllInputsValid();
      houseNumber.text = box.get("Pick Up House Number") ?? "";
    }
    streetName.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put("Pick Up Street Name", sanitizeInput(streetName.value.text));
      });
    });
    buildingName.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put(
            "Pick Up Building Name", sanitizeInput(buildingName.value.text));
      });
    });
    houseNumber.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put("Pick Up House Number", sanitizeInput(houseNumber.value.text));
      });
    });

    if (box.get("Drop Off Street Name").toString().isNotEmpty) {
      areAllInputsValid();
      dropOffStreetName.text = box.get("Drop Off Street Name") ?? "";
    }
    if (box.get("Drop Off Building Name").toString().isNotEmpty) {
      areAllInputsValid();
      dropOffBuildingName.text = box.get("Drop Off Building Name") ?? "";
    }
    if (box.get("Drop Off House Number").toString().isNotEmpty) {
      areAllInputsValid();
      dropOffHouseNumber.text = box.get("Drop Off House Number") ?? "";
    }
    dropOffStreetName.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put("Drop Off Street Name",
            sanitizeInput(dropOffStreetName.value.text));
      });
    });
    dropOffBuildingName.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put("Drop Off Building Name",
            sanitizeInput(dropOffBuildingName.value.text));
      });
    });
    dropOffHouseNumber.addListener(() {
      areAllInputsValid();
      setState(() {
        box.put("Drop Off House Number",
            sanitizeInput(dropOffHouseNumber.value.text));
      });
    });
  }

  bool areAllInputsValid() {
    List<TextEditingController> controllers = [
      streetName,
      buildingName,
      houseNumber,
      dropOffStreetName,
      dropOffBuildingName,
      dropOffHouseNumber,
    ];

    for (var controller in controllers) {
      if (controller.text.length <= 1) {
        setState(() {
          activeSubmit = false;
        });
        return false;
      }
    }

    setState(() {
      if (ischecked) {
        activeSubmit = true;
      } else {
        activeSubmit = false;
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Enter Additional Address Information",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              try{
                Navigator.pop(context,"");
              }
              catch(e,stackTrace){
                print('Error while popping: $e');
                print(stackTrace);
              }

            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: ischecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          ischecked = newValue ?? false;
                          areAllInputsValid();
                        });
                        print(newValue);
                      },
                    ),
                    const Flexible(
                      child: const Text(
                        "I confirm that all information provided is accurate and complete.",
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                ischecked
                    ? Wrap(
                        children: [
                          TextInput(
                            inputColor: const Color(0xAAFFFFFF),
                            label: "Street/Road Name For Pick-up Location *",
                            helper: "Enter The Pick-up street name",
                            hint: " ",
                            controller: streetName,
                          ),
                          streetName.value.text.isNotEmpty
                              ? TextInput(
                                  inputColor: const Color(0xAAFFFFFF),
                                  label: "Building name For Pick-up Location *",
                                  helper: "Enter The Pick-up Building name",
                                  hint: " ",
                                  controller: buildingName,
                                )
                              : Container(),
                          streetName.value.text.isNotEmpty &&
                                  buildingName.value.text.isNotEmpty
                              ? TextInput(
                                  inputColor: const Color(0xAAFFFFFF),
                                  label:
                                      "Apartment/Flat/House/Office number For Pickup Location*",
                                  helper:
                                      "Enter The Pick-up Apartment/Flat/House/Office number",
                                  hint: " ",
                                  controller: houseNumber,
                                )
                              : Container(),

                          streetName.value.text.isNotEmpty &&
                                  buildingName.value.text.isNotEmpty &&
                                  houseNumber.value.text.isNotEmpty
                              ? TextInput(
                                  inputColor: const Color(0xAAFFFFFF),
                                  label:
                                      "Street/Road Name For Drop off Location *",
                                  helper: "Enter your street name",
                                  hint: " ",
                                  controller: dropOffStreetName,
                                )
                              : Container(),
streetName.value.text.isNotEmpty &&
        buildingName.value.text.isNotEmpty &&
        houseNumber.value.text.isNotEmpty && dropOffStreetName.value.text.isNotEmpty

        ? TextInput(
                            inputColor: const Color(0xAAFFFFFF),
                            label: "Building name For Drop off Location *",
                            helper: "Enter The Drop Off Building name",
                            hint: " ",
                            controller: dropOffBuildingName,
                          ):Container(),
                          streetName.value.text.isNotEmpty &&
                                  buildingName.value.text.isNotEmpty &&
                                  houseNumber.value.text.isNotEmpty &&
                                  dropOffStreetName.value.text.isNotEmpty &&
                                  dropOffBuildingName.value.text.isNotEmpty
                              ? TextInput(
                            inputColor: const Color(0xAAFFFFFF),
                            label:
                                "Apartment/Flat/House/Office number For Drop off Location *",
                            helper:
                                "Enter The Drop Off Apartment/Flat/House/Office number",
                            hint: " ",
                            controller: dropOffHouseNumber,
                          ):Container(),
                        ],
                      )
                    : Container(), //street name
                // directions description
                ischecked

                    ? Wrap(
                        spacing: 100,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CustomDropdown(
                                items: const [
                                  "Yes, there is a dog at the Pick-up Location. ",
                                  "No, there are no dogs/there is no dog at the Pick-up Location.",
                                  "There is a dog, and it is dangerous at the Pick-up Location."
                                ],
                                onChanged: (value) {
                                  box.put("Information Regarding Dog Pick Up",
                                      value);
                                  setState(() {
                                    areAllInputsValid();
                                  });
                                }),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CustomDropdown(
                                items: const [
                                  "Yes, there is a dog at the Drop Off Location. ",
                                  "No, there are no dogs/there is no dog at the Drop Off Location.",
                                  "There is a dog, and it is dangerous at the Drop Off Location."
                                ],
                                onChanged: (value) {
                                  box.put("Information Regarding Dog Drop Off",
                                      value);
                                  setState(() {
                                    areAllInputsValid();
                                  });
                                }),
                          ),
                        ],
                      )
                    : Container(),

                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: MaterialButton(
                      color: Colors.blueAccent.withOpacity(0.8),
                      onPressed: activeSubmit
                          ? () {
                              Navigator.pop(
                                context,
                                "submitted",
                              );
                            }
                          : null,
                      child: const Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

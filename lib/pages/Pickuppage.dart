import 'package:_247_door_delivery/pages/Dropoffpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../Apis/Autocomplete.dart';

class PickupLocationScreen extends StatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  final TextEditingController _searchFieldController = TextEditingController();
  dynamic suggestions = [];
  var box = Hive.box("PickupDetails");
  var cbox = Hive.box("CustomerInfo");

  // To store the suggestions from the response

  @override
  void initState() {
    super.initState();

    _searchFieldController.addListener(() {
      if (_searchFieldController.text.isNotEmpty) {
        search(_searchFieldController.text);
      }
      if (_searchFieldController.text.isEmpty) {
        setState(() {
          suggestions = [];
        });
      }
    });
  }

  void search(String text) async {
    try {
      List<dynamic> fetchedSuggestions =
          await sendPlaceAutocompleteRequest(text);

      // Use setState to update suggestions if fetchedSuggestions is not null
      setState(() {
        suggestions =
            fetchedSuggestions ?? []; // Ensure suggestions is not null
      });
    } catch (error) {
      print('Error during search: $error');
      setState(() {
        suggestions = []; // Set an empty list if an error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Set Pickup Location',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchFieldController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  labelText: "Search an address...",
                  focusColor: Colors.grey,
                  hoverColor: Colors.white30,
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  fillColor: const Color(0xFFFFFFFF),
                  filled: true,
                  prefixIcon: const Icon(Icons.search)),
            ),
            Expanded(
              child: suggestions.isNotEmpty && suggestions != null
                  ? ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        var suggestion = suggestions[index]['placePrediction'];
                        var mainText = suggestion['structuredFormat']
                            ?['mainText']?['text'];
                        var secondaryText = suggestion['structuredFormat']
                            ?['secondaryText']?['text'];

                        return Column(
                          children: [
                            ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.location_on),
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text(
                                "$mainText",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              subtitle: secondaryText != null
                                  ? Text(
                                      "$secondaryText",
                                      style: GoogleFonts.poppins(fontSize: 10),
                                    )
                                  : const Text(""),
                              onTap: () {
                                var placeId = suggestion['placeId'];
                                var mainText = suggestion['structuredFormat']
                                    ?['mainText']?['text'];
                                var subText = suggestion['structuredFormat']
                                    ?['secondaryText']?['text'];
                                Map pickUpData = {
                                  'placeId': placeId,
                                  'mainText': mainText,
                                  'subText': subText
                                };
                                box.putAll(pickUpData);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DropoffLocationScreen()));
                                // Handle tap on a suggestion (e.g., navigate or use the placeId)
                              },
                            ),
                            if (index < suggestion.length - 1)
                              Divider(
                                thickness: 1,
                                color: Colors.grey[200],
                              ),
                          ],
                        );
                      },
                    )
                  : const Center(child: Text('No suggestions available')),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, home: PickupLocationScreen()));

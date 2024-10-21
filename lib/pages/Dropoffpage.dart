import 'dart:convert';
import 'package:_247_door_delivery/pages/Finalpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Apis/Autocomplete.dart';

class DropoffLocationScreen extends StatefulWidget {
  const DropoffLocationScreen({super.key});

  @override
  State<DropoffLocationScreen> createState() => _DropoffLocationScreenState();
}

class _DropoffLocationScreenState extends State<DropoffLocationScreen> {
  final TextEditingController _searchFieldController = TextEditingController();
  dynamic suggestions = [];
  var box = Hive.box("DropoffDetails");

  // To store the suggestions from the response

  @override
  void initState() {
    // TODO: implement initState
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

        title:  Text('Set Drop off Location',style: GoogleFonts.poppins(fontWeight: FontWeight.w300,fontSize: 18),),


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
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300)),

                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  fillColor: Color(0xFFFFFFFF),
                  filled: true,
                  prefixIcon: Icon(Icons.search)),
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
                                  : Text(""),
                              onTap: () {
                                // Handle tap on a suggestion (e.g., navigate or use the placeId)
                                var placeId = suggestion['placeId'];
                                var mainText = suggestion['structuredFormat']
                                    ?['mainText']?['text'];
                                var subText = suggestion['structuredFormat']
                                    ?['secondaryText']?['text'];
                                Map dropOffData = {
                                  'placeId': placeId,
                                  'mainText': mainText,
                                  'subText': subText
                                };
                                box.putAll(dropOffData);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalDetails()));
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

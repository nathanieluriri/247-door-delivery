import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class MyCameraApp extends StatefulWidget {
  @override
  _MyCameraAppState createState() => _MyCameraAppState();
}

class _MyCameraAppState extends State<MyCameraApp> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _imagePath;
  bool cameraShowing = false;
  bool previewOn = true;
  bool isLoading = false;
  var box4 = Hive.box("CameraDetails");
  Timer? _timer;
  bool? shouldRedirect;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: 700), () {
      setState(() {
        

      });
    });
    // Get a list of available cameras
    availableCameras().then((cameras) {
      // Initialize the camera controller
      _controller = CameraController(
        cameras[0], // Select the first camera
        ResolutionPreset.ultraHigh,
      );

      _initializeControllerFuture = _controller?.initialize();
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      setState(() {
        previewOn ? previewOn = false : previewOn = true;
      });

      final image = await _controller?.takePicture();
      setState(() {
        _imagePath = image?.path; // Store the image path
      });
    } catch (e) {
      print(e); // Handle any exceptions
    }
  }

  Future<void> _uploadImage(String imagePath) async {
    try {
      final image = await http.get(Uri.parse(imagePath));

      String base64Image = base64Encode(image.bodyBytes);
      // base64Image =Uri.encodeComponent(base64Image);
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse('https://image-hosting-api-theta.vercel.app/upload'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'base64_image': base64Image}),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully ${response.body}');
        box4.put("ImageId", response.body);
        box4.put("shouldRedirect", true);
        Navigator.pop(context);
      } else {
        print('Upload failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    print("should redirect $shouldRedirect");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload a Picture of the Package',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_imagePath != null) Image.network(_imagePath!),
                  cameraShowing
                      ? FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: previewOn
                                    ? CameraPreview(_controller!)
                                    : Container(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      : Container(),
                  cameraShowing && previewOn
                      ? ElevatedButton(
                          onPressed: _takePicture,
                          child: Text('Take Picture'),
                        )
                      : cameraShowing == false && previewOn
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cameraShowing = true;
                                });
                              },
                              child: Text('Open Camera'),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      cameraShowing = true;
                                    });
                                    _uploadImage(_imagePath!);
                                  },
                                  child: Text('Use Image'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      cameraShowing = true;
                                      previewOn = true;
                                      _imagePath = null;
                                      _initializeControllerFuture =
                                          _controller?.initialize();
                                    });
                                  },
                                  child: Text('Retake Picture'),
                                ),
                              ],
                            )
                  // Display the captured image
                ],
              ),
      ),
    );
  }
}

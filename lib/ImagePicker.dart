import 'dart:typed_data'; // For Uint8List
import 'dart:convert'; // For base64 encoding
import 'package:_247_door_delivery/pages/Finalpage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
class MyWebImagePickerApp extends StatefulWidget {

  @override
  _MyWebImagePickerAppState createState() => _MyWebImagePickerAppState();
}

class _MyWebImagePickerAppState extends State<MyWebImagePickerApp> {
  String? _base64Image;
  bool isLoading = false;
  dynamic box = Hive.box("CameraDetails");
  int time = 1000;
  final GlobalKey<_CircularProgressLoaderState> loaderKey =
  GlobalKey<_CircularProgressLoaderState>();


  Future<void> _pickImage() async {
    // Pick the image as bytes (Uint8List)
    Uint8List? imageBytes = await ImagePickerWeb.getImageAsBytes();


    if (imageBytes != null) {
      // Convert the image bytes to base64
      String base64String = base64Encode(imageBytes);

      setState(() {
        _base64Image = base64String; // Store the base64 string
      });

      print('Base64 Image String: $_base64Image');
    } else {
      print('No image selected.');
    }
  }
  Future<void> _uploadImage(String? base64Image) async {
    try {
      setState(() {
        isLoading = true;

      });
      final response = await http.post(
        Uri.parse('https://image-hosting-api-theta.vercel.app/upload'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'base64_image': base64Image!}),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully ${response.body}');
        box.put("ImageId", response.body);
        box.put("shouldRedirect", true);


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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload a Picture of the Package',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FinalDetails()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading?CircularProgressLoader():
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _base64Image != null
                ? Base64ImageExample(base64Image: _base64Image)
                : Text('No image picked yet'),
            SizedBox(height: 20),
            _base64Image == null? ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ):Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ()async{_uploadImage(_base64Image);},

                  child: Text('Use the Image'),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Another Image'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Base64ImageExample extends StatelessWidget {
  final String? base64Image;

  Base64ImageExample({super.key, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    // Decode the Base64 string
    Uint8List bytes = base64Decode(base64Image!);

    return Container( height: 500,
      child: Center(
        child: Image.memory(bytes,fit: BoxFit.contain,),
      ),
    );
  }
}


class CircularProgressLoader extends StatefulWidget {
  CircularProgressLoader({Key? key}) : super(key: key);
  @override
  _CircularProgressLoaderState createState() => _CircularProgressLoaderState();
}

class _CircularProgressLoaderState extends State<CircularProgressLoader> {
  double _progress = 0.0;
  Timer? _timer;
  int milliseconds = 1000;

  @override
  void initState() {
    super.initState();
    _startLoading();

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startLoading() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {

      setState(() {
        dynamic box = Hive.box("CameraDetails");
        dynamic condition = box.get("shouldRedirect");
        if (condition==true){
          speedUpLoading();
        }
        _progress += 0.01; // Increment by 1%
        if (_progress >= 1.0) {
          _timer?.cancel();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FinalDetails()),
          );
        }
      });
    });
  }
  void speedUpLoading() {

    setState(() {
      milliseconds = 4; // Set faster interval to 10ms
      _startLoading();   // Restart the loading process with the new speed
    });
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Circular progress indicator
            CircularProgressIndicator(
              value: _progress, // Set progress value
              strokeWidth: 2.3,
            ),
            SizedBox(height: 20),
            // Display progress percentage
            Text(
              '${(_progress * 100).toInt()}%', // Convert progress to percentage
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}


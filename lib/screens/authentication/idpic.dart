// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ilugan_passsenger/firebase_helpers/fetching.dart';
import 'package:ilugan_passsenger/screens/authentication/idverification.dart';
// import 'package:ilugan_passsenger/screens/authentication/idverification.dart';
// import 'package:ilugan_passsenger/screens/authentication/signup_fordiscounted.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/idverification.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class PhotoIdScreen extends StatefulWidget {
  PhotoIdScreen({super.key, required this.type});

  String type;

  @override
  _PhotoIdScreenState createState() => _PhotoIdScreenState();
}

class _PhotoIdScreenState extends State<PhotoIdScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? fcmtoken;

  @override
  void initState() {
    super.initState();
    gettoken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void gettoken() async {
    String? response = await FetchingData().getUSerToken();
    setState(() {
      fcmtoken = response;
    });
    print(fcmtoken);
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  // Function to take a photo using the camera
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

    void uploadIdToStorage() async {
    if (_imageFile != null) {
      QuickAlert.show(context: context, type: QuickAlertType.loading, text: 'Sending request...', title: 'Processing');
      File file = _imageFile!;
      String path = 'idpictures/${file.path.split('/').last}';
      final storageRef = FirebaseStorage.instance.ref().child(path);

      UploadTask uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      });

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print('File uploaded!');
      });

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print('Download URL: $downloadURL');

      await FirebaseFirestore.instance
          .collection('admin_requests')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'email': FirebaseAuth.instance.currentUser!.email,
        'type': widget.type,
        'imagelocation': downloadURL,
        'accepted': false,
        'status' : 'pending',
        'reason': ""
      });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AdminVerification(idimage: _imageFile as File, type: widget.type,)));
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload ID Photo'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // Display the selected image or a placeholder
            Expanded(
              child: Center(
                child: _imageFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 100,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No image selected',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: 250,
                          height: 250,
                        ),
                      ),
              ),
            ),

            // Buttons for choosing from gallery and taking a photo
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: TextContent(name: 'Choose From Gallery', fcolor: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: TextContent(name: 'Take Photo', fcolor: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            // Spacer to push "Next" button to the bottom of the screen
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Only show 'Next' button if an image is selected
      floatingActionButton: _imageFile != null
          ? FloatingActionButton.extended(
              onPressed: uploadIdToStorage,
              label: const Text('Next'),
              icon: const Icon(Icons.arrow_forward),
              backgroundColor: Colors.blueAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

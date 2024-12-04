// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/manyreservation.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:quickalert/quickalert.dart';

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen(
      {super.key,
      required this.compName,
      required this.companyId,
      required this.busnum,
      required this.currentlocation,
      required this.destination,
      required this.destinationcor,
      required this.bustype,
      required this.compId
      // required this.seatQuantity
      });

  final String companyId;
  final String compName;
  final String busnum;
  final LatLng currentlocation;
  final String compId;
  // final String pickuploc;
  final LatLng destinationcor;
  final String destination;
  final String bustype;
  // final int seatQuantity;

  @override
  _ReservationDetailsScreenState createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  final _seniorsController = TextEditingController();
  final _regularsController = TextEditingController();
  final _studentsController = TextEditingController();
  final _pwdController = TextEditingController();
  String? pickuploc;
  int totalpassengers = 0;

  File? _uploadedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = File(pickedFile.path);
      });
    }
  }

  void getPickuploc() async {
    try {
      String response = await ApiCalls().reverseGeocode(
          widget.currentlocation.latitude, widget.currentlocation.longitude);
      setState(() {
        pickuploc = response;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getPickuploc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextContent(name: "Reservation Details", fcolor: Colors.white),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Passenger Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildPassengerInputField('Number of Seniors', _seniorsController),
            _buildPassengerInputField(
                'Number of Regulars', _regularsController),
            _buildPassengerInputField(
                'Number of Students', _studentsController),
            _buildPassengerInputField('Number of PWD', _pwdController),
            SizedBox(height: 30),
            Text(
              'Upload Supporting Documents (if any):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _showImageSourceDialog();
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: _uploadedImage == null
                    ? Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _uploadedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print(widget.bustype);
                int quanseniors = 0;
                int quanpwd = 0;
                int quanstudent = 0;
                int quanreg = 0;
                if (_seniorsController.text == "" &&
                    _pwdController.text == "" &&
                    _regularsController.text == "" &&
                    _studentsController.text == "") {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Reservation Error',
                      text: "All the fields can't be blank");
                } else {
                  try {
                    if (_seniorsController.text != "") {
                      quanseniors = int.parse(_seniorsController.text);
                    }
                    if (_pwdController.text != "") {
                      quanpwd = int.parse(_pwdController.text);
                    }
                    if (_regularsController.text != "") {
                      quanreg = int.parse(_regularsController.text);
                    }
                    if (_studentsController.text != "") {
                      quanstudent = int.parse(_studentsController.text);
                    }
                    if (quanstudent > 0 || quanpwd > 0 || quanseniors > 0) {
                      totalpassengers =
                          (quanreg + quanstudent + quanpwd + quanseniors);
                      if (totalpassengers > 1) {
                        if (widget.bustype == 'Regular') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ManyReservationDetailsScreen(
                                    companyName: widget.compName,
                                    busNumber: widget.busnum,
                                    origin: pickuploc.toString(),
                                    destination: widget.destination,
                                    distance: '70 km',
                                    fare: '90',
                                    students: quanstudent,
                                    seniors: quanseniors,
                                    pwd: quanpwd,
                                    regulars: quanreg,
                                    origincoordinates: widget.currentlocation,
                                    bustype: widget.bustype,
                                    destincor: widget.destinationcor,
                                    companyId: widget.compId,
                                  )));
                        } else {
                          if (_uploadedImage == null) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title:
                                    "Please upload some identification for the PWD, Seniors or Student that you entered");
                          } else {
                            print('Going to validation');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ManyReservationDetailsScreen(
                                      companyName: widget.compName,
                                      busNumber: widget.busnum,
                                      origin: pickuploc.toString(),
                                      destination: widget.destination,
                                      distance: '70 km',
                                      fare: '90',
                                      students: quanstudent,
                                      seniors: quanseniors,
                                      pwd: quanpwd,
                                      regulars: quanreg,
                                      origincoordinates: widget.currentlocation,
                                      bustype: widget.bustype,
                                      ids: _uploadedImage,
                                      destincor: widget.destinationcor,
                                      companyId: widget.compId,
                                    )));
                          }
                        }
                      } else {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Reservation Error',
                            text: "More than 1 reservations are required");
                      }
                    } else {
                      if (quanreg < 2) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Reservation Error',
                            text: "More than 1 reservations are required");
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ManyReservationDetailsScreen(
                                  companyName: widget.compName,
                                  busNumber: widget.busnum,
                                  origin: pickuploc.toString(),
                                  destination: widget.destination,
                                  distance: '70 km',
                                  fare: '90',
                                  students: quanstudent,
                                  seniors: quanseniors,
                                  pwd: quanpwd,
                                  regulars: quanreg,
                                  origincoordinates: widget.currentlocation,
                                  bustype: widget.bustype,
                                  destincor: widget.destinationcor,
                                  companyId: widget.compId,
                                )));
                      }
                    }
                  } catch (error) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Rservation Error",
                        text: "You entered an invalid data");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  'Request Reservation',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerInputField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

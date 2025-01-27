// ignore_for_file: must_be_immutable, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/waitingscreen.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:quickalert/quickalert.dart';
import 'package:path/path.dart' as path;
import 'package:quickalert/quickalert.dart';

class ManyReservationDetailsScreen extends StatefulWidget {
  final String companyName;
  final String busNumber;
  final String origin;
  final String destination;
  final String distance;
  final String fare;
  final int students;
  final int seniors;
  final int pwd;
  final int regulars;
  final LatLng origincoordinates;
  final String bustype;
  File? ids;
  String? idurl;
  final LatLng destincor;
  final String companyId;

  ManyReservationDetailsScreen(
      {super.key,
      required this.companyName,
      required this.busNumber,
      required this.origin,
      required this.origincoordinates,
      required this.destination,
      required this.distance,
      required this.fare,
      required this.students,
      required this.seniors,
      required this.pwd,
      required this.regulars,
      required this.bustype,
      this.ids,
      this.idurl,
      required this.destincor,
      required this.companyId});

  @override
  State<ManyReservationDetailsScreen> createState() =>
      _ManyReservationDetailsScreenState();
}

class _ManyReservationDetailsScreenState
    extends State<ManyReservationDetailsScreen> {
  Widget detailTile({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 30, color: Colors.redAccent),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget passengerDetail({
    required String label,
    required int count,
    required IconData icon,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.redAccent,
          radius: 25,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          "$count",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  double totalfare = 0;
  String? distance;

  void getDistance() async {
    try {
      String? d = await ApiCalls()
          .getDistance(widget.origincoordinates, widget.destincor);
      if (d != null) {
        distance = d;
        calculatefare();
      }
    } catch (error) {
      print(error);
    }
    print(distance);
  }

  void sendRequestToBusConductor(Map<String, dynamic> requestData) async {
    try {
      // Reference to the requests collection
      CollectionReference requestsRef = FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .collection('buses')
          .doc(widget.busNumber)
          .collection('requests');

      // Fetch all documents in the collection
      QuerySnapshot snapshot = await requestsRef.get();

      // Generate the next document ID (assuming 0-based indexing)
      int nextId = snapshot.docs.length + 1;

      // Create a new document with the auto-incremented ID
      await requestsRef.doc(nextId.toString()).set(requestData);
      Navigator.of(context).pop();
      print("Request sent successfully with ID: $nextId");

      String type = "";
      if(widget.pwd > 0){
        type += ' PWD';
      }
      if(widget.students > 0){
        type += ' Student';
      }
      if(widget.seniors > 0){
        type += ' Senior';
      }
      if(widget.regulars > 0){
        type += ' Regular';
      }
      print(type);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => WaitingForAcceptanceScreen(
                companyId: widget.companyId,
                busNumber: widget.busNumber,
                requestId: nextId,
                amount: totalfare,
                companyname: widget.companyName,
                destination: widget.destination,
                distance: widget.distance,
                pickup_location: widget.origin,
                type: type,
                seatsquantity: (widget.pwd + widget.regulars + widget.seniors + widget.students),
              )));
    } catch (error) {
      Navigator.of(context).pop();
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: error.toString());
      print("Error sending request: $error");
    }
  }

  void calculatefare() {
    if (widget.bustype == 'Air-Conditioned') {
      if (double.parse(distance.toString().split(' ')[0]) <= 30 &&
              distance.toString().split(' ')[1] == 'km' ||
          double.parse(distance.toString().split(' ')[0]) <= 999.9 &&
              distance.toString().split(' ')[1] == 'm') {
        totalfare =
            ((widget.pwd + widget.regulars + widget.seniors + widget.students) *
                48);
      } else {
        if (widget.pwd > 0 || widget.seniors > 0 || widget.students > 0) {
          totalfare = totalfare +
              (((((double.parse(distance.toString().split(' ')[0]) - 30) * 2) +
                          48) *
                      0.80) *
                  (widget.pwd + widget.seniors + widget.students));
        }

        totalfare = totalfare +
            (((double.parse(distance.toString().split(' ')[0]) - 30) * 2) + 48);
      }
    } else if (widget.bustype == 'Regular') {
      totalfare =
          ((widget.pwd + widget.regulars + widget.seniors + widget.students) *
              (double.parse(distance.toString().split(' ')[0]) * 2));
    }
    setState(() {});
  }

  Future<String?> uploadFileToFirebase(File file) async {
    try {
      // Get file name
      String fileName = path.basename(file.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('ids/$fileName');

      // Upload file
      TaskSnapshot uploadTask = await storageRef.putFile(file);

      // Get download URL
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Future<void> sendReservationRequest(){

  // }

  @override
  void initState() {
    super.initState();
    getDistance();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Details
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/icons/dagupan_bus.png'),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.companyName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Bus #${widget.busNumber}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Journey Details
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    detailTile(
                      label: "From",
                      value: '${widget.origin.substring(0, 15)}...',
                      icon: Icons.location_on_outlined,
                    ),
                    const Divider(),
                    detailTile(
                      label: "To",
                      value: '${widget.destination.substring(0, 15)}...',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Passenger Details
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Passengers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        passengerDetail(
                          label: "Students",
                          count: widget.students,
                          icon: Icons.school,
                        ),
                        passengerDetail(
                          label: "Seniors",
                          count: widget.seniors,
                          icon: Icons.elderly,
                        ),
                        passengerDetail(
                          label: "PWD",
                          count: widget.pwd,
                          icon: Icons.accessible,
                        ),
                        passengerDetail(
                          label: "Regular",
                          count: widget.regulars,
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Distance and Fare Details
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    detailTile(
                      label: "Distance",
                      value:
                          distance != null ? distance.toString() : 'Loading..',
                      icon: Icons.route,
                    ),
                    const Divider(),
                    detailTile(
                      label: "Fare",
                      value: totalfare != 0
                          ? '${totalfare.toStringAsFixed(2)} Php'
                          : 'Loading...',
                      icon: Icons.monetization_on,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Reserve Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Handle reservation confirmation
                  if (totalfare == 0 && distance == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Your data is still being calculated")),
                    );
                  } else {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        title: 'Sending Request',
                        text: 'Please wait a moment');
                    // Check if IDs file is not null
                    if (widget.ids != null) {
                      print('With image');
                      String? fileUrl = await uploadFileToFirebase(widget.ids!);
                      if (fileUrl != null) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text("File uploaded successfully! URL: $fileUrl"),
                        //   ),
                        // );
                        // Proceed with reservation process

                        Map<String, dynamic> content = {
                          'pickup_location': widget.origin,
                          'pickup_location_coordinates': GeoPoint(
                              widget.origincoordinates.latitude,
                              widget.origincoordinates.longitude),
                          'destination': widget.destination,
                          'destination_coordinates': GeoPoint(
                              widget.destincor.latitude,
                              widget.destincor.longitude),
                          'fare': totalfare,
                          'distance': distance,
                          'totalpassengers': (widget.pwd +
                              widget.regulars +
                              widget.seniors +
                              widget.students),
                          'pwds': widget.pwd,
                          'seniors': widget.seniors,
                          'students': widget.students,
                          'regulars': widget.regulars,
                          'status': 'pending',
                          'reason': '',
                          'seats': [],
                          'ids': fileUrl,
                          'datesent': DateTime.now()
                        };
                        sendRequestToBusConductor(content);

                        print(content);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Reservation Confirmed!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("File upload failed. Try again.")),
                        );
                      }
                    } else if (widget.idurl != null && widget.ids == null) {
                      print('Usingonly one acc');
                      Map<String, dynamic> content = {
                        'pickup_location': widget.origin,
                        'pickup_location_coordinates': GeoPoint(
                            widget.origincoordinates.latitude,
                            widget.origincoordinates.longitude),
                        'destination': widget.destination,
                        'destination_coordinates': GeoPoint(
                            widget.destincor.latitude,
                            widget.destincor.longitude),
                        'fare': totalfare,
                        'distance': distance,
                        'totalpassengers': (widget.pwd +
                            widget.regulars +
                            widget.seniors +
                            widget.students),
                        'pwds': widget.pwd,
                        'seniors': widget.seniors,
                        'students': widget.students,
                        'regulars': widget.regulars,
                        'status': 'pending',
                        'reason': '',
                        'seats': [],
                        'ids': widget.idurl,
                        'datesent': DateTime.now()
                      };
                      sendRequestToBusConductor(content);
                    } else {
                      print('regular');
                      Map<String, dynamic> content = {
                        'pickup_location': widget.origin,
                        'pickup_location_coordinates': GeoPoint(
                            widget.origincoordinates.latitude,
                            widget.origincoordinates.longitude),
                        'destination': widget.destination,
                        'destination_coordinates': GeoPoint(
                            widget.destincor.latitude,
                            widget.destincor.longitude),
                        'fare': totalfare,
                        'distance': distance,
                        'totalpassengers': (widget.pwd +
                            widget.regulars +
                            widget.seniors +
                            widget.students),
                        'pwds': widget.pwd,
                        'seniors': widget.seniors,
                        'students': widget.students,
                        'regulars': widget.regulars,
                        'status': 'pending',
                        'reason': '',
                        'seats': [],
                        'ids': "",
                        'datesent': DateTime.now()
                      };
                      print(content);
                      sendRequestToBusConductor(content);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("ID file is missing!")),
                      // );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    // primary: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.redAccent),
                child: const Text(
                  "Send Reservation Request",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

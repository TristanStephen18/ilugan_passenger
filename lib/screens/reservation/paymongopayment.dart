// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:ilugan_passenger_mobile_app/api/apicalls.dart';
// import 'package:ilugan_passenger_mobile_app/screens/reservation/ticketdownload.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/ticketdownload.dart';
// import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen(
      {super.key,
      required this.link,
      required this.companyId,
      required this.current,
      required this.currentlocc,
      required this.destination,
      required this.amount,
      required this.busnum,
      required this.companyname,
      required this.distance,
      required this.type,
      required this.resnum,
      required this.paymentId,
      required this.seatsquantity,
      required this.busseats
      });

  DateTime current;
  String currentlocc;
  String destination;
  String amount;
  String busnum;
  String companyname;
  String companyId;
  String distance;
  String type;
  String resnum;
  String paymentId;
  final int seatsquantity;
  final List<dynamic> busseats;

  final String
      link; // Make it a final since it's passed as a required argument.

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController controller;
  String? paymentlink;
  int occ = 0;
  int reserved = 0;
  int seatsavail = 0;

  @override
  void initState() {
    super.initState();
    print(widget.resnum);

    // Initialize the payment link when the widget is created.
    paymentlink = widget.link;
    getBusData();
    checkpayment();

    // Initialize the WebView controller when the payment link is available.
    if (paymentlink != null) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(paymentlink!));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String today = DateFormat.yMMMMd('en_US').format(DateTime.now());

  void addCompanyIncome() async {
    double income = 0;
    int numberOfPassengers = 0;
    int numberofreservations = 0;

    // Reference to the document you want to update
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('data')
        .doc(today);

    try {
      // Fetch current data from Firestore
      DocumentSnapshot snapshot = await documentRef.get();

      if (snapshot.exists) {
        // Document exists, retrieve current values
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        income = (data['total_income'] ?? 0).toDouble();
        numberOfPassengers = (data['total_passengers'] ?? 0).toInt();
        numberofreservations = (data['total_reservation'] ?? 0).toInt();
      }

      // Calculate new totals
      double newIncome = income + double.parse(widget.amount.toString());
      int newNumberOfPassengers = numberOfPassengers + widget.seatsquantity;
      int newnumberofReservations = numberofreservations + widget.seatsquantity;

      // Set the document with updated values (or create it if it doesn’t exist)
      await documentRef.set({
        'total_income': newIncome,
        'total_passengers': newNumberOfPassengers,
        'total_reservation': newnumberofReservations
      }, SetOptions(merge: true)).then((value) {
        addBusIncome();
      });

      print('Company data updated with new income and passenger count.');
    } catch (e) {
      print('Error updating bus income: $e');
    }
  }

  void addBusIncome() async {
    double income = 0;
    int numberOfPassengers = 0;
    int numberofreservations = 0;

    // Reference to the document you want to update
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .collection('data')
        .doc(today)
        ;

    try {
      // Fetch current data from Firestore
      DocumentSnapshot snapshot = await documentRef.get();

      if (snapshot.exists) {
        // Document exists, retrieve current values
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        income = (data['total_income'] ?? 0).toDouble();
        numberOfPassengers = (data['total_passengers'] ?? 0).toInt();
        numberofreservations = (data['total_reservations'] ?? 0).toInt();
        
      }

      // Calculate new totals
      double newIncome = income + double.parse(widget.amount.toString());
      int newNumberOfPassengers = numberOfPassengers + widget.seatsquantity;
      int newnumberofreservations = numberofreservations + widget.seatsquantity;

      // Set the document with updated values (or create it if it doesn’t exist)
      await documentRef.set({
        'total_income': newIncome,
        'total_passengers': newNumberOfPassengers,
        'total_reservations' : newnumberofreservations
      }, SetOptions(merge: true)).then((value) {
        Navigator.of(context).pop();
        // QuickAlert.show(context: context, type: type)
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Ticket(
                  amount: widget.amount,
                  busnum: widget.busnum,
                  companyname: widget.companyname,
                  current: widget.current,
                  currentlocc: widget.currentlocc,
                  destination: widget.destination,
                  distance: widget.distance,
                  type: widget.type,
                  resnum: widget.resnum,
                  seatquantity: widget.seatsquantity,
                  seats: widget.busseats,
                )));
      });

      print('Bus data updated with new income and passenger count.');
    } catch (e) {
      print('Error updating bus income: $e');
    }
  }

  String? presID;

  Future<void> updateDocument() async {
    await FirebaseFirestore.instance
        .collection('passengers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'hasreservation': true, 'busnum': widget.busnum, 'current_reservation': widget.resnum});
      print("update Successful");
      await FirebaseFirestore.instance
          .collection('passengers')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('reservations')
          .doc()
          .set({
        "reservation_number": widget.resnum,
        "date_and_time": widget.current,
        "from": widget.currentlocc,
        "to": widget.destination,
        "fare": double.parse(widget.amount.toString()),
        "distance_traveled": widget.distance,
        "busnumber": widget.busnum,
        "bus_company": widget.companyname,
        "label" : "pending",
        "type" : widget.type,
      }).then((value) {
        addCompanyIncome();
        print("Reservation Successful");
      }).catchError((error) {
        print(error.toString());
      });
  }

  Future<void> updateBusData(int avail, int occu, int res) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .update({
      'available_seats': avail - widget.seatsquantity,
      'occupied_seats': occu + widget.seatsquantity,
      'reserved_seats': res + widget.seatsquantity
    }).then((value) {
      print('Bus Data Updated');
    }).catchError((error) {
      print('Error updating the bus data');
    });
  }

  void getBusData() {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          seatsavail = data['available_seats'];
          occ = data['occupied_seats'];
          reserved = data['reserved_seats'];
        });
      } else {
        print('Unable to find data');
      }
    });
  }

  Timer? _checkstatustimer;

  void checkpayment() {
    print("clicked");
    _checkstatustimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Call the async function separately
      // print(link.split(" ")[1]);
      String? status = await ApiCalls().checkpaymentstatus(widget.paymentId);
      print(status);
      if (status == "paid") {
        print("Payment successful, cancelling timer.");
        _checkstatustimer?.cancel(); // Use the passed timer to cancel
        reserve();
      }
    });
  }

  void reserve() async {
    QuickAlert.show(context: context, type: QuickAlertType.loading, title: 'Now Reserving', text: 'Processing your reservation...');
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .collection('reservations')
        .doc(widget.resnum)
        .set({
      'passengerId': FirebaseAuth.instance.currentUser!.uid,
      'amount': double.parse(widget.amount.toString()),
      'distance': widget.distance,
      'from': widget.currentlocc,
      'to': widget.destination,
      'date_time': widget.current,
      'seats_reserved': widget.seatsquantity,
      'seats': widget.busseats,
      'accomplished': false,
      'type' : widget.type

    }).then((value) {
      updateBusData(seatsavail, occ, reserved);
      updateDocument();
      // Navigator.of(context).pop();
    }).catchError((error) {
      Navigator.of(context).pop();
      QuickAlert.show(context: context, type: QuickAlertType.error, title: 'Reservation Error', text: error.message);
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paymentlink != null
          ? WebViewWidget(controller: controller)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

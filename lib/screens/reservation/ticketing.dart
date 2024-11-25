// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/paymongopayment.dart';
import 'package:ilugan_passsenger/screens/reservation/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen(
      {super.key,
      required this.companyId,
      required this.current,
      required this.currentlocc,
      required this.destination,
      required this.amount,
      required this.busnum,
      required this.companyname,
      required this.distance,
      required this.type});

  DateTime current;
  String currentlocc;
  String destination;
  String amount;
  String busnum;
  String companyname;
  String companyId;
  String distance;
  String type;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusData();
    createpaymentlink();
    getReservationNumber();
  }

  String link = "";

  void createpaymentlink() async {
    String? paymentlink =
        await ApiCalls().createPayMongoPaymentLink(double.parse(widget.amount));

    setState(() {
      link = paymentlink.toString();
    });

    print(paymentlink);
  }

  // String? presID;
  int occ = 0;
  int reserved = 0;
  int seatsavail = 0;

  // Future<void> updateDocument() async {
  //   await FirebaseFirestore.instance
  //       .collection('passengers')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .update({
  //     'hasreservation': true,
  //   }).then((_) async {
  //     print("update Successful");
  //     await FirebaseFirestore.instance
  //         .collection('passengers')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('reservations')
  //         .doc(presID)
  //         .set({
  //       "reservation_number": resnum,
  //       "date_and_time": widget.current,
  //       "from": widget.currentlocc,
  //       "to": widget.destination,
  //       "fare": double.parse(widget.amount.toString()),
  //       "distance_traveled": widget.distance,
  //       "busnumber": widget.busnum,
  //       "bus_company": widget.companyname
  //     }).then((value) {
  //       print("Reservation Successful");
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (_) => Ticket(
  //                 amount: widget.amount,
  //                 busnum: widget.busnum,
  //                 companyname: widget.companyname,
  //                 current: widget.current,
  //                 currentlocc: widget.currentlocc,
  //                 destination: widget.destination,
  //                 distance: widget.distance,
  //                 type: widget.type,
  //                 resnum: resnum as String,
  //               )));
  //     }).catchError((error) {
  //       print(error.toString());
  //     });
  //   }).catchError((error) {
  //     print('Failed to update document: $error');
  //   });
  // }

  // Future<void> updateBusData(int avail, int occu, int res) async {
  //   await FirebaseFirestore.instance
  //       .collection('companies')
  //       .doc(widget.companyId)
  //       .collection('buses')
  //       .doc(widget.busnum)
  //       .update({
  //     'available_seats': avail - 1,
  //     'occupied_seats': occu + 1,
  //     'reserved_seats': res + 1
  //   }).then((value) {
  //     print('Bus Data Updated');
  //   }).catchError((error) {
  //     print('Error updating the bus data');
  //   });
  // }

  String? conductorname;

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
          conductorname = data['conductor'];
        });
      } else {
        print('Unable to find data');
      }
    });
  }

  String? resnum;
  bool ispaying = false;
  // Timer? _checkstatustimer;

  // void checkpayment() {
  //   print("clicked");
  //   _checkstatustimer =
  //       Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     // Call the async function separately
  //     print(link.split(" ")[1]);
  //     String? status = await ApiCalls().checkpaymentstatus(link.split(" ")[1]);
  //     print(status);
  //     if (status == "paid") {
  //       print("Payment successful, cancelling timer.");
  //       _checkstatustimer?.cancel(); // Use the passed timer to cancel
  //       reserve();
  //     }
  //   });
  // }

// Future<void> _checkPaymentStatus(Timer timer) async {
//   print(link.split(" ")[1]);
//   String? status = await ApiCalls().checkpaymentstatus(link.split(" ")[1]);
//   print(status);
//   if (status == "paid") {
//     print("Payment successful, cancelling timer.");
//     timer.cancel();  // Use the passed timer to cancel
//     reserve();
//   }
// }

  void getReservationNumber() async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .collection('reservations')
        .get();

    if (snapshots.docs.isEmpty) {
      resnum = "000001";
    } else {
      int entries = snapshots.docs.length + 1;
      String reservationNumber = entries.toString().padLeft(6, '0');
      resnum = reservationNumber;
      print('REservation number is: $reservationNumber');
    }

    setState(() {});
  }

  // void reserve() async {
  //   await FirebaseFirestore.instance
  //       .collection('companies')
  //       .doc(widget.companyId)
  //       .collection('buses')
  //       .doc(widget.busnum)
  //       .collection('reservations')
  //       .doc(resnum)
  //       .set({
  //     'passengerId': FirebaseAuth.instance.currentUser!.uid,
  //     'amount': double.parse(widget.amount.toString()),
  //     'distance': widget.distance,
  //     'from': widget.currentlocc,
  //     'to': widget.destination,
  //     'date_time': widget.current,
  //     'seats_reserved': 1,
  //     'accomplished': false
  //   }).then((value) {
  //     updateBusData(seatsavail, occ, reserved);
  //     updateDocument();
  //     // Navigator.of(context).pop();
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

  void showwarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextContent(name: "Attention"),
          content: TextContent(
              name:
                  "Note: This ticket is non-refundable and only valid until the date of purchase."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                        amount: widget.amount,
                        busnum: widget.busnum,
                        companyId: widget.companyId,
                        companyname: widget.companyname,
                        current: widget.current,
                        currentlocc: widget.currentlocc,
                        destination: widget.destination,
                        distance: widget.distance,
                        paymentId: link.split(" ")[1],
                        resnum: resnum.toString(),
                        type: widget.type,
                        link: link.split(" ")[0])));
                setState(() {
                  ispaying = !ispaying;
                });
              },
              child: Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                // Handle cancel action
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ispaying ? Colors.white : const Color.fromARGB(255, 182, 179, 179),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: TextContent(
          name: 'Ticketing',
          fontsize: 20,
          fcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ispaying
          ? const Paying()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  height: MediaQuery.sizeOf(context).height,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Gap(10),
                        resnum != null
                            ? TextContent(
                                name: 'Reservation #: $resnum',
                                fontsize: 16,
                                fontweight: FontWeight.bold,
                              )
                            : const CircularProgressIndicator(),
                        TextContent(
                          name: widget.companyname,
                          fontweight: FontWeight.w600,
                        ),
                        TextContent(
                          name: widget.busnum,
                          fontweight: FontWeight.w400,
                        ),
                        const Divider(),
                        const Gap(20),
                        TicketDataDisplayer(
                          leading: const Icon(Icons.location_history),
                          subtitle: TextContent(
                            name: widget.currentlocc,
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: 'Pick Up Location',
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        // const Divider()
                        TicketDataDisplayer(
                          leading: const Icon(Icons.location_searching_rounded),
                          subtitle: TextContent(
                            name: widget.destination,
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: 'Destination',
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),

                        TicketDataDisplayer(
                          leading: const Icon(Icons.chair),
                          subtitle: TextContent(
                            name: 'Availed Seats',
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: '1 seat',
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        TicketDataDisplayer(
                          leading: const Icon(
                            Icons.php,
                            size: 30,
                          ),
                          subtitle: TextContent(
                            name: 'Fare',
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: widget.amount,
                            fontsize: 18,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        TicketDataDisplayer(
                          leading: const Icon(Icons.discount),
                          subtitle: TextContent(
                            name: 'Discounted',
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: widget.type != "Regular" ? '20%' : "None",
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        TicketDataDisplayer(
                          leading: const Icon(Icons.route),
                          subtitle: TextContent(
                            name: 'Distance',
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: widget.distance,
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        TicketDataDisplayer(
                          leading: const Icon(Icons.person_4),
                          subtitle: TextContent(
                            name: 'Conductor',
                            fontsize: 15,
                          ),
                          title: TextContent(
                            name: conductorname.toString(),
                            fontsize: 15,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        link != ""
                            ? EButtons(
                                onPressed: showwarning,
                                //  () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (_) => PaymentScreen(
                                //         amount: widget.amount,
                                //         busnum: widget.busnum,
                                //         companyId: widget.companyId,
                                //         companyname: widget.companyname,
                                //         current: widget.current,
                                //         currentlocc: widget.currentlocc,
                                //         destination: widget.destination,
                                //         distance: widget.distance,
                                //         paymentId: link.split(" ")[1],
                                //         resnum: resnum.toString(),
                                //         type: widget.type,
                                //         link: link.split(" ")[0])));
                                // setState(() {
                                //   ispaying = !ispaying;
                                // });
                                // },
                                name: 'Pay Now',
                                bcolor: Colors.redAccent,
                                tcolor: Colors.white,
                              )
                            : const CircularProgressIndicator(),
                        const Spacer(),
                        // 09287044227
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class Paying extends StatelessWidget {
  const Paying({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          const Image(
            image: AssetImage('assets/icons/payment.jpg'),
            height: 300,
            width: 300,
          ),
          const Gap(20),
          TextContent(
            name: "Payment in process...",
            fcolor: Colors.black,
            fontsize: 30,
            fontweight: FontWeight.bold,
          ),
          const Spacer()
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/notifications/model.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:quickalert/quickalert.dart';

class WaitingForAcceptanceScreen extends StatefulWidget {
  final String companyId;
  final String busNumber;
  final double amount;
  final int requestId; // This is the auto-incremented ID for the document

  const WaitingForAcceptanceScreen({
    Key? key,
    required this.companyId,
    required this.busNumber,
    required this.requestId,
    required this.amount
  }) : super(key: key);

  @override
  State<WaitingForAcceptanceScreen> createState() => _WaitingForAcceptanceScreenState();
}

class _WaitingForAcceptanceScreenState extends State<WaitingForAcceptanceScreen> {

  String link = "";

  void createpaymentlink() async {
    String? paymentlink;
    print('sample');
    if(widget.amount < 100){
      print('less than 10 ${widget.amount * 10}');
    paymentlink =
        await ApiCalls().createPayMongoPaymentLink(widget.amount * 10);
    }else{
       print('greater than 10 ${widget.amount}');
       paymentlink =
        await ApiCalls().createPayMongoPaymentLink(widget.amount);
    }
    setState(() {
      link = paymentlink.toString();
    });

    print(paymentlink);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createpaymentlink();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextContent(name: "Requests Status", fcolor: Colors.white),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .doc(widget.companyId)
            .collection('buses')
            .doc(widget.busNumber)
            .collection('requests')
            .doc(
                widget.requestId.toString()) // Listen to the specific request document
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Request not found!"),
            );
          }

          // Retrieve the status from the document
          final request = snapshot.data!;
          final status = request['status'];
          final reason = request['reason'];
          final seatsassigned = request['seats'];

          if (status == 'accepted' && seatsassigned.length > 0) {
            return const Center(
                child: Text("Request accepted! Redirecting..."));
          } else if (status == 'rejected') {
            Notif().rejectedrequestnotif(reason.toString());
            Navigator.of(context).pop();
          }

          // Display waiting UI
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  "Waiting for acceptance...\nCurrent status: $status",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Accepted"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Your request has been accepted!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Return to Home",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class TicketView extends StatefulWidget {
  TicketView(
      {super.key,
      required this.date,
      required this.currentlocc,
      required this.destination,
      required this.amount,
      required this.busnum,
      required this.companyname,
      required this.distance,
      required this.type,
      required this.resnum});

  DateTime date;
  String currentlocc;
  String destination;
  String amount;
  String busnum;
  String companyname;
  String distance;
  String type;
  String resnum;

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ui.Color.fromARGB(255, 202, 201, 201),
      appBar: AppBar(
        title: TextContent(name: "Travel History", fcolor: Colors.white),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: _downloadImage,
        //       icon: const Icon(
        //         Icons.download,
        //         color: Colors.white,
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  height: MediaQuery.sizeOf(context).height / 1.3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        Center(
                          child: Column(
                            children: [
                              TextContent(
                          name: 'Reservation #: ${widget.resnum}',
                          fontsize: 16,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(name: DateFormat('MMMM, d, y').format(widget.date), fontweight: FontWeight.w500,),
                        TextContent(
                          name: widget.companyname,
                          fontweight: FontWeight.w600,
                        ),
                        TextContent(
                          name: widget.busnum,
                          fontweight: FontWeight.w400,
                        ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const Gap(20),
                        // Replacing TicketViewDataDisplayer with TextContent
                        TextContent(
                          name: 'Pick Up Location:\n \t${widget.currentlocc.toUpperCase()}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Destination:\n \t${widget.destination.toUpperCase()}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Availed Seats: 1 seat',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Fare: ${widget.amount}',
                          fontsize: 18,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name:
                              'Discounted: ${widget.type != "Regular" ? "20%" : "None"}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Distance traveled: ${widget.distance}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        const Gap(20),
                        Center(
                          child: QrImageView(
                            data: widget.resnum,
                            size: 200,
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

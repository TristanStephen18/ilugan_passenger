// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
// import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class Ticket extends StatefulWidget {
  Ticket(
      {super.key,
      required this.current,
      required this.currentlocc,
      required this.destination,
      required this.amount,
      required this.busnum,
      required this.companyname,
      required this.distance,
      required this.type,
      required this.resnum});

  DateTime current;
  String currentlocc;
  String destination;
  String amount;
  String busnum;
  String companyname;
  String distance;
  String type;
  String resnum;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  // void _downloadImage() async {
  //   try {
  //     RenderRepaintBoundary? boundary = _repaintkey.currentContext
  //         ?.findRenderObject() as RenderRepaintBoundary?;

  //     if (boundary == null) {
  //       throw Exception('Render boundary is null');
  //     }

  //     // Proceed with capturing the image
  //     ui.Image image = await boundary.toImage();
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();

  //     final result = await ImageGallerySaver.saveImage(pngBytes,
  //         quality: 100,
  //         name: "screenshot_${DateTime.now().millisecondsSinceEpoch}");

  //     if (result['isSuccess']) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Image Saved'),
  //         backgroundColor: Colors.green,
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Failed to Save Image'),
  //         backgroundColor: Colors.red,
  //       ));
  //     }

  //     print('Image Saved: ${result['filePath']}');
  //   } catch (e) {
  //     print('Error saving image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Error Saving Image'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

  // DateTime formatdate(){
  //   return
  // }

  final _repaintkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ui.Color.fromARGB(255, 202, 201, 201),
      appBar: AppBar(
        title: TextContent(name: "TICKET", fcolor: Colors.white),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: _repaintkey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  height: MediaQuery.sizeOf(context).height / 1.4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Gap(10),
                        TextContent(
                          name: 'Reservation #: ${widget.resnum}',
                          fontsize: 16,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(name: DateFormat('MMMM, d, y').format(widget.current), fontweight: FontWeight.w500,),
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
                        // Replacing TicketDataDisplayer with TextContent
                        TextContent(
                          name: 'Pick Up Location: ${widget.currentlocc}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Destination: ${widget.destination}',
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
                          name: 'Distance: ${widget.distance}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        const Gap(20),
                        QrImageView(
                          data: widget.resnum,
                          size: 200,
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Gap(10),
            EButtons(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const HomeScreen()));
            }, 
            name: "Go to home", 
            tcolor: Colors.white,
            bcolor: Colors.redAccent,
            )
          ],
        ),
      ),
    );
  }
}

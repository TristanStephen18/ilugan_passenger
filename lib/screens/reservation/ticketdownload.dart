import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/screens/userscreens/homescreen.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

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
      required this.resnum,
      required this.seatquantity,
      required this.seats,
      });

  DateTime current;
  String currentlocc;
  String destination;
  String amount;
  String busnum;
  String companyname;
  String distance;
  String type;
  String resnum;
  final int seatquantity;
  final List<dynamic> seats;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  final _repaintkey = GlobalKey();

  void _downloadImage() {
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket saved in gallery'),
            backgroundColor: Colors.green,
          )
    );
    // try {
    //   RenderRepaintBoundary? boundary =
    //       _repaintkey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    //   if (boundary == null) throw Exception('Render boundary is null');

    //   ui.Image image = await boundary.toImage();
    //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //   Uint8List pngBytes = byteData!.buffer.asUint8List();

    //   final result = await ImageGallerySaver.saveImage(
    //     pngBytes,
    //     quality: 100,
    //     name: "ticket_${DateTime.now().millisecondsSinceEpoch}",
    //   );

    //   if (result['isSuccess']) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Ticket saved in gallery'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //   } else {
    //     throw Exception('Failed to save image');
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Error saving ticket'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
            'Have you taken a screenshot or saved the ticket? Because it will be needed for your reservation.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

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
            onPressed: _downloadImage,
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          )
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
                  height: MediaQuery.sizeOf(context).height / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Gap(10),
                        TextContent(
                          name: 'Reservation #: ${widget.resnum}',
                          fontsize: 16,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: DateFormat('MMMM, d, y').format(widget.current),
                          fontweight: FontWeight.w500,
                        ),
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
                          name: 'Availed Seats: ${widget.seatquantity} seat',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Fare: ${widget.amount} php',
                          fontsize: 18,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name:
                              'Type: ${widget.type}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(
                          name: 'Distance: ${widget.distance}',
                          fontsize: 15,
                          fontweight: FontWeight.bold,
                        ),
                        TextContent(name: 'Seat Numbers: ${widget.seats}'),
                        const Gap(40),
                        QrImageView(
                          data: widget.resnum,
                          size: 270,
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Gap(10),
            EButtons(
              onPressed: _showConfirmationDialog,
              name: "Go to home",
              tcolor: Colors.white,
              bcolor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/screens/reservation/pickuplocationselection.dart';
import 'package:ilugan_passsenger/screens/reservation/reservationdetailsinput.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class ReservationChoiceScreen extends StatefulWidget {
  const ReservationChoiceScreen({super.key, required this.companyId,
      required this.compName,
      required this.busnum,
      required this.currentlocation,
      required this.via,
      required this.bustype
      });

      final String companyId;
      final String compName;
      final String busnum;
      final LatLng currentlocation;
      final String via;
      final String bustype;

  @override
  State<ReservationChoiceScreen> createState() => _ReservationChoiceScreenState();
}

class _ReservationChoiceScreenState extends State<ReservationChoiceScreen> {

  int seatquantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextContent(
          name: widget.busnum,
          fontsize: 20,
          fcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(MediaQuery.sizeOf(context).height/5),
            Text(
              'Who are you reserving for?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Add your navigation logic for "For Me" here
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PickupLocationChoiceScreen(compName: widget.compName, companyId: widget.companyId, busnum: widget.busnum, currentlocation: widget.currentlocation, seatQuantity: seatquantity, via: widget.via, bustype: widget.bustype,)));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Gap(MediaQuery.sizeOf(context).width/3  ),
                  Text(
                    'For Me',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Icon(Icons.person, color: Colors.white)
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PickupLocationChoiceScreen(compName: widget.compName, companyId: widget.companyId, busnum: widget.busnum, currentlocation: widget.currentlocation, seatQuantity: 10, via: widget.via, bustype: widget.bustype,)));
                // Add your navigation logic for "For Me and Others" here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Gap(MediaQuery.sizeOf(context).width/4  ),
                    Text(
                      'For Me and Others',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Icon(Icons.people, color: Colors.white,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

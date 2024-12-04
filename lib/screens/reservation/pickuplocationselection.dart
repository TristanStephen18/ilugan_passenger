import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/pickuplocation.dart';
import 'package:ilugan_passsenger/screens/reservation/selectdestination.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:quickalert/quickalert.dart';

class PickupLocationChoiceScreen extends StatefulWidget {
  const PickupLocationChoiceScreen(
      {super.key,
      required this.compName,
      required this.companyId,
      required this.busnum,
      required this.currentlocation,
      required this.seatQuantity,
      required this.via,
      required this.bustype
      });

  final String companyId;
  final String compName;
  final String busnum;
  final LatLng currentlocation;
  final int seatQuantity;
  final String via;
  final String bustype;

  @override
  State<PickupLocationChoiceScreen> createState() =>
      _PickupLocationChoiceScreenState();
}


class _PickupLocationChoiceScreenState
    extends State<PickupLocationChoiceScreen> {

      LatLng? currentcoordinates;

// void initializedata(){
//   setState(() {
    
//   });
// }

Future<String?> getcurrentlocation() async {
  String? address = await  ApiCalls().reverseGeocode(widget.currentlocation.latitude, widget.currentlocation.longitude);
  return address;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextContent(
          name: 'Pick up location',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(MediaQuery.sizeOf(context).height/5),
            Text(
              'How would you like to set your pickup location?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async{
                QuickAlert.show(context: context, type: QuickAlertType.loading, title: 'Getting current location',);
                String? address = await  ApiCalls().reverseGeocode(widget.currentlocation.latitude, widget.currentlocation.longitude);
                // QuickAlert.show(context: context, type: QuickAlertType.loading, headerBackgroundColor: Colors.red, title: 'Pick up location', text: 'Getting Current location');
                if(address != null){
                  print('Address has been fetched');
                  print(address);
                  Navigator.of(context).pop();
                  QuickAlert.show(context: context, type: QuickAlertType.success, headerBackgroundColor: Colors.red, title: 'Current Location Fetched!', text: 'Location Update!', confirmBtnText: 'Next', onConfirmBtnTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SelectLocationScreen(companyId: widget.companyId, compName: widget.compName, busnum: widget.busnum, pickupaddress: address.toString(), pickupcoordinates: LatLng(widget.currentlocation.latitude, widget.currentlocation.longitude), seatQuantity: widget.seatQuantity, bustype: widget.bustype,)));
                  });
                }
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
                  Gap(MediaQuery.sizeOf(context).width / 6),
                  Text(
                    'Use my current location',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Icon(Icons.place_outlined, color: Colors.white)
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SelectPickUpLocationScreen(companyId: widget.companyId, compName: widget.compName, busnum: widget.busnum, via: widget.via, seatQuantity: widget.seatQuantity, bustype: widget.bustype)));
                // Add logic to use the user's current location
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
                  Gap(MediaQuery.sizeOf(context).width / 6),
                  Text(
                    'Choose a pick up location',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Icon(Icons.ads_click, color: Colors.white)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

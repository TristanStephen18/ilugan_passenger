// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ilugan_passenger_mobile_app/screens/reservation/reservation.dart';
// import 'package:ilugan_passenger_mobile_app/screens/reservation/selectdestination.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/screens/reservation/selectdestination.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:status_alert/status_alert.dart';

class DisplayItems {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showbusinfo(
      BuildContext context,
      String buscompany,
      String busnumber,
      String platenumber,
      String currentlocation,
      int availableseats,
      int occupied,
      int reserved,
      String companyId,
      LatLng currentloc,
      bool hasreservation,
      LatLng destinationcoordinates,
      LatLng buslocation
      ) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextContent(
              name: 'Bus Information',
              fontsize: 20,
              fontweight: FontWeight.bold,
              fcolor: Colors.black,
            ),
            const Gap(10),
            Row(
              children: [
                const Image(
                    height: 110,
                    width: 150,
                    image: AssetImage('assets/icons/dagupan_bus.png')),
                const Gap(10),
                Column(
                  children: [
                    TextContent(
                      name: buscompany,
                      fontweight: FontWeight.bold,
                      fcolor: Colors.black,
                      fontsize: 20,
                    ),
                    TextContent(
                      name: busnumber,
                      fontsize: 18,
                      fontweight: FontWeight.w600,
                      fcolor: Colors.black,
                    )
                  ],
                ),
              ],
            ),
            TextContent(
              name: 'Currently at: ',
              fontsize: 17,
              fontweight: FontWeight.bold,
              fcolor: Colors.black,
            ),
            const Gap(10),
            TextContent(
              name: currentlocation,
              fontsize: 15,
              fcolor: Colors.black,
            ),
            const Gap(15),
            TextContent(
              name: 'Route',
              fcolor: Colors.black,
              fontweight: FontWeight.bold,
              fontsize: 17,
            ),
            Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.directions),
                    TextContent(
                        name: 'Cubao',
                        fcolor: Colors.black,
                        fontweight: FontWeight.bold)
                  ],
                ),
                TextContent(
                  name: '-------------------->',
                  fcolor: Colors.black,
                  fontweight: FontWeight.bold,
                ),
                Column(
                  children: [
                    const Icon(Icons.location_on),
                    TextContent(
                      name: 'Dagupan',
                      fcolor: Colors.black,
                      fontweight: FontWeight.bold,
                    )
                  ],
                )
              ],
            ),
            const Gap(20),
            TextContent(
              name: 'Seating Info',
              fcolor: Colors.black,
              fontweight: FontWeight.bold,
              fontsize: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextContent(
                      name: 'Available',
                      fcolor: Colors.black,
                      fontweight: FontWeight.bold,
                    ),
                    const Gap(10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 54, 150, 42)),
                      child: Center(
                        child: Text(
                          availableseats.toString(),
                          style: const TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextContent(
                      name: 'Occupied',
                      fcolor: Colors.black,
                      fontweight: FontWeight.bold,
                    ),
                    const Gap(10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 219, 59, 59)),
                      child: Center(
                        child: TextContent(
                          name: occupied.toString(),
                          fcolor: const Color.fromARGB(255, 197, 197, 197),
                          fontsize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextContent(
                      name: 'Reserved',
                      fcolor: Colors.black,
                      fontweight: FontWeight.bold,
                    ),
                    const Gap(10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 226, 230, 48)),
                      child: Center(
                        child: TextContent(
                          name: reserved.toString(),
                          fcolor: Colors.black,
                          fontsize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(20),
            OutlinedButton(
                onPressed: () {
                  if (availableseats == 0) {
                    // print("you can't reserve a seat when the bus is full");
                    StatusAlert.show(
                      context,
                      title: 'Bus is fully occupied',
                      configuration: const IconConfiguration(
                          icon: Icons.bus_alert_outlined, color: Colors.red),
                      duration: const Duration(seconds: 1),
                    );
                  } else if (hasreservation) {
                    StatusAlert.show(
                      context,
                      title: 'You already have a reservation',
                      configuration: const IconConfiguration(
                          icon: Icons.error, color: Colors.red),
                      duration: const Duration(seconds: 1),
                    );
                  } else {
                    print('Now reserving');
                    // StatusAlert.show(
                    //   context,
                    //   title: 'reserving seats',
                    //   configuration: const IconConfiguration(
                    //     icon: Icons.run_circle,
                    //     color: Colors.red
                    //   ),
                    //   duration: const Duration(seconds: 1),
                    // );
                    // Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SelectLocationScreen(
                              companyId: companyId,
                              compName: buscompany,
                              busnum: platenumber,
                              currentloc: currentloc,
                              destinationloc: destinationcoordinates,
                              currentlocation: buslocation,
                            )));
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: availableseats == 0
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  foregroundColor:
                      availableseats == 0 ? Colors.white : Colors.white,
                  fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                ),
                child: TextContent(
                  name: availableseats == 0
                      ? 'STANDING/FULLY OCCUPIED'
                      : 'RESERVE A SEAT',
                  fcolor: Colors.black,
                  fontsize: 20,
                ))
          ],
        ),
      ),
    ));
  }
}



// class UserDataGetter{
//   String getusername(){
//     String username = "";
//     User? user = FirebaseAuth.instance.currentUser;

    

//     return username;
//   }
// }

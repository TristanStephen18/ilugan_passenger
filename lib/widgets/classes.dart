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
  void showBusInfoDialog(
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
  LatLng buslocation,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Image(
                      height: 100,
                      width: 150,
                      image: AssetImage('assets/icons/dagupan_bus.png'),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buscompany,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          busnumber,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Currently at:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentlocation,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Route',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.directions, color: Colors.black),
                        Text(
                          'Cubao',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '---------------------->',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        Text(
                          'Dagupan',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Seating Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSeatInfoColumn('Available', availableseats,
                        Color(0xFF36962A)), // Green
                    _buildSeatInfoColumn('Occupied', occupied,
                        Color(0xFFDB3B3B)), // Red
                    _buildSeatInfoColumn('Reserved', reserved,
                        Color(0xFFE2E630)), // Yellow
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (availableseats == 0) {
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SelectLocationScreen(
                            companyId: companyId,
                            compName: buscompany,
                            busnum: platenumber,
                            currentloc: currentloc,
                            destinationloc: destinationcoordinates,
                            currentlocation: buslocation,
                          ),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  availableseats == 0 ? Colors.grey: Colors.redAccent ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      availableseats == 0
                          ? 'STANDING/FULLY OCCUPIED'
                          : 'RESERVE A SEAT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSeatInfoColumn(String label, int count, Color color) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}

}



// class UserDataGetter{
//   String getusername(){
//     String username = "";
//     User? user = FirebaseAuth.instance.currentUser;

    

//     return username;
//   }
// }

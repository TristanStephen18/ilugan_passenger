// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusMonitoring {
  void listentobuslocation(String companyid, String busnum, String resnum) async {
    String? location = await getFirstReservation(companyid, resnum, busnum);
    print('Reservation NUmber is: $resnum');
    print(location);

    if(location != null){
      LatLng? locationcoordinates =
        await ApiCalls().getCoordinates(location as String);

    print("Location: $location and Location Coordinates: $locationcoordinates");

    if (locationcoordinates != null) {
      FirebaseFirestore.instance
          .collection('companies')
          .doc(companyid)
          .collection('buses')
          .doc(busnum)
          .snapshots()
          .listen((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('collection found');
          var data = snapshot.data() as Map<String, dynamic>;
          // print(myloc);
          print(data['current_location']);
          GeoPoint geoPoint = data['current_location'] ?? const GeoPoint(0, 0);
          String? distance = await ApiCalls().getDistance(
              LatLng(geoPoint.latitude, geoPoint.longitude),
              locationcoordinates);
          print(distance);
          print('Distance label: ${distance.toString().split(' ')[1]}');
          if (double.parse(distance.toString().split(' ')[0]) <= 3 &&
              distance.toString().split(' ')[1] == 'm') {
            print('bus has arrived at pick up location');
            busArrivalNotifications(
                'has arrived at $location', busnum, 'We hope you are here');
                
          }
          if (double.parse(distance.toString().split(' ')[0]) <= 2 &&
              distance.toString().split(' ')[1] == 'km') {
            busArrivalNotifications('is arriving at $location', busnum,
                'Be ready for your reservation\nThank you!');
          }
          if (double.parse(distance.toString().split(' ')[0]) <= 999 && double.parse(distance.toString().split(' ')[0]) >= 4  &&
              distance.toString().split(' ')[1] == 'm') {
            busArrivalNotifications('is getting closer to $location', busnum,
                'Be ready for your reservation\nThank you!');
          }
          // print(distance.toString().split(''));
          // if(double.parse(distance.toString().split('')[0]) <= 2){
          //   print('You bus is approaching');
          // }
        } else {
          print('notfound');
        }
      });
    }
    }else{
      print('Location is null');
    }
  }

  Future<String?> getFirstReservation(String compid, String id, String busnum) async {

    print(id);

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('companies')
        .doc(compid)
        .collection('buses')
        .doc(busnum)
        .collection('reservations')
        .doc(id)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      print(data);
      print("Pick up location at: ${data['from']}");
      return data['from'];
    }
    return null;
  }

  void busArrivalNotifications(String body, String busnum, String message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 2, // A unique ID for this notification
          channelKey:
              'ilugan_notif', // Channel should match the one initialized
          title: 'Bus update',
          body: '$busnum $body\n$message',
          notificationLayout:
              NotificationLayout.Default, // Default notification layout
          // icon: 'resource://drawable/logo',
          ),
    ).then((val){
      addtoNotifications('Bus Arrival Monitoring', '$busnum $body\n$message');
    });
  }

  Future<void> addtoNotifications(String title, String content)async{
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).collection('notifications').doc().set({
      'title' : title,
      'content' : content,
      'dateNtime' : DateTime.now()
    }).then((val){
      print('notifications added to Notification collections');
    });
  }
}

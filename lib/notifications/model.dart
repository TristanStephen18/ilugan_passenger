// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notif{

    Future<void> requestNotificationPermissions(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Show a dialog prompting the user to allow notifications
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Allow Notifications'),
          content: Text('This app would like to send you notifications.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Deny'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await AwesomeNotifications().requestPermissionToSendNotifications();
              },
              child: Text('Allow'),
            ),
          ],
        ),
      );
    }
  }


    static Future<void> initializenotifications() async {
      await AwesomeNotifications().initialize(
      'resource://drawable/logo',  // Set your notification icon here
      [
        NotificationChannel(
          channelKey: 'ilugan_notif',
          channelName: 'Ilugan Channel',
          channelDescription: 'Notifying Passengers',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
    );
    print('NOtifications initialized');
    }

  void verificationnotification(String title, String status) {
  print('Creating notification with title: $title and status: $status'); // Debugging print
   DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM d, y - h:mm a').format(now);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 19, // A unique ID for this notification
      channelKey: 'ilugan_notif', // Channel should match the one initialized
      title: 'Your ID verification has failed',
      body: title,
      notificationLayout: NotificationLayout.Default,
      // icon: 'assets/images/logo/logo.png'
    ),
  ).then((val) async {
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).collection('notifications').doc().set({
      'content': 'Your ID verification has failed',
      'dateNtime': now,
      'title': 'Failed ID verification',
    });
  });
}

void successverificationnotification() {
  // print('Creating notification with title: $title and status: $status'); // Debugging print
   DateTime now = DateTime.now();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 13, // A unique ID for this notification
      channelKey: 'ilugan_notif', // Channel should match the one initialized
      title: 'Your ID has been successfully verified',
      body: 'You can now enjoy your 20% discount',
      notificationLayout: NotificationLayout.Default,
      // icon: 'assets/images/logo/logo.png'
    ),
  ).then((val) async {
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).collection('notifications').doc().set({
      'content': 'Your ID has been successfully verified',
      'dateNtime': now,
      'title': 'ID verified',
    });
  });
}

  void accountcreationnotification() {
    // String accountcreationtime = DateFormat()
  // print('Creating notification with title: $title and status: $status'); // Debugging print
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM d, y - h:mm a').format(now);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1, // A unique ID for this notification
      channelKey: 'ilugan_notif', // Channel should match the one initialized
      title: 'Account Creation Notification',
      body: 'Your ilugan account was created at $formattedDate',
      notificationLayout: NotificationLayout.Default,
      // icon: 'assets/images/logo/logo.png'
    ),
  ).then((val) async {
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).collection('notifications').doc().set({
      'content': 'Your ilugan account was created at $formattedDate',
      'dateNtime': now,
      'title': 'Account Creation Notification',
    });
  });
}


void reservationnotification(String busnum, String companyname, String resnum) {
    // String accountcreationtime = DateFormat()
  // print('Creating notification with title: $title and status: $status'); // Debugging print
  DateTime now = DateTime.now();
  // String formattedDate = DateFormat('MMMM d, y - h:mm a').format(now);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 12, // A unique ID for this notification
      channelKey: 'ilugan_notif', // Channel should match the one initialized
      title: 'Reservation Successful',
      body: 'You have reserved a seat at $companyname: $busnum with the reservation number of $resnum',
      notificationLayout: NotificationLayout.Default,
      // icon: 'assets/images/logo/logo.png'
    ),
  ).then((val) async {
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).collection('notifications').doc().set({
      'content': 'You have reserved a seat at $companyname: $busnum with the reservation number of $resnum',
      'dateNtime': now,
      'title': 'Reservation Successful',
    });
  });
}

void rejectedrequestnotif(String reason) {
    // String accountcreationtime = DateFormat()
  // print('Creating notification with title: $title and status: $status'); // Debugging print
  DateTime now = DateTime.now();
  // String formattedDate = DateFormat('MMMM d, y - h:mm a').format(now);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 15, // A unique ID for this notification
      channelKey: 'ilugan_notif', // Channel should match the one initialized
      title: 'Your Request was Rejected',
      body: 'The conductor has rejected your request due to $reason',
      notificationLayout: NotificationLayout.Default,
      // icon: 'assets/images/logo/logo.png'
    ),
  );
}


}
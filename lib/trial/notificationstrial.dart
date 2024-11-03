import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationstrialScreen extends StatelessWidget {
  const NotificationstrialScreen({super.key});

  void createBasicNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10, // A unique ID for this notification
        channelKey: 'ilugan_notif', // Channel should match the one initialized
        title: 'Hello Flutter!',
        body: 'This is a simple notification created with Awesome Notifications.',
        notificationLayout: NotificationLayout.Default, // Default notification layout
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async{
           bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

            if (!isAllowed) {
              // Request permission to send notifications
              await AwesomeNotifications().requestPermissionToSendNotifications();
            } else {
              createBasicNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Notifications are already enabled")),
              );
            }
        }, child: const Text('Send Notif')),
      ),
    );
  }
}
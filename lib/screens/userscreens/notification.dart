import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  // List of notifications
  final List<Map<String, String>> notifications = [
    {"title": "Notification 1", "message": "This is the first notification."},
    {"title": "Notification 2", "message": "This is the second notification."},
    {"title": "Notification 3", "message": "This is the third notification."},
    {"title": "Notification 4", "message": "This is the fourth notification."},
    {"title": "Notification 5", "message": "This is the fifth notification."},
    {"title": "Notification 6", "message": "This is the sixth notification."},
    {"title": "Notification 7", "message": "This is the seventh notification."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['message']!),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // You can add functionality here when a notification is tapped
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Clicked on ${notifications[index]['title']}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
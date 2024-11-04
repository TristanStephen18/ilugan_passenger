import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Map to hold notifications grouped by date
  Map<String, List<Map<String, String>>> notificationsByDate = {};

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() {
    FirebaseFirestore.instance
        .collection('passengers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        notificationsByDate.clear();
        for (var doc in snapshot.docs) {
          var data = doc.data();
          // Parse the timestamp field to DateTime
          DateTime dateTime = (data['dateNtime'] as Timestamp).toDate();
          // Format date to "October 3, 2024"
          String formattedDate = DateFormat('MMMM d, y').format(dateTime);

          // Add the notification under the formatted date
          if (notificationsByDate[formattedDate] == null) {
            notificationsByDate[formattedDate] = [];
          }
          notificationsByDate[formattedDate]!.add({
            'title': data['title'],
            'message': data['content'],
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notificationsByDate.keys.length,
        itemBuilder: (context, dateIndex) {
          String date = notificationsByDate.keys.elementAt(dateIndex);
          List<Map<String, String>> notifications = notificationsByDate[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date label
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              // List of notifications for that date
              ...notifications.map((notification) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(notification['title']!),
                    subtitle: Text(notification['message']!),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Clicked on ${notification['title']}'),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

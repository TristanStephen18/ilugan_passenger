import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  void initState() {
    super.initState();
    fecthnotifications();
  }
  // List of notifications
List<Map<String, String>> notifications = [
  ];

  void fecthnotifications() {
  FirebaseFirestore.instance
      .collection('passengers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notifications')
      .snapshots()
      .listen((snapshot) {
    setState(() {
      notifications.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        notifications.add({
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
        // ignore_for_file: avoid_print
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
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
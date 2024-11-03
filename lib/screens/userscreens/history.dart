// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ilugan_passsenger/screens/userscreens/historyviewer.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/ticketview.dart';
import 'package:ilugan_passsenger/screens/userscreens/ticketview.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Bus Travel History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: const ReservationList(),
    );
  }
}

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  final String passengerId = FirebaseAuth.instance.currentUser!.uid;
  String? acctype;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    getAccountType();
  }

  Future<void> getAccountType() async {
    // Simulating the FetchingData().getacctype() function.
    String? type = 'Regular'; // Dummy data for testing
    setState(() {
      acctype = type;
    });
  }

  // Helper function to format Firestore Timestamp.
  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – kk:mm a').format(date);
  }

  // Filter Function for Date Range
  bool filterByDate(Timestamp timestamp) {
    if (selectedDateRange == null) return true;
    DateTime date = timestamp.toDate();
    return date.isAfter(selectedDateRange!.start) && date.isBefore(selectedDateRange!.end);
  }

  // Build the filter UI
  void openFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter History by Date'),
          content: ListTile(
            title: const Text('Select Date Range'),
            subtitle: selectedDateRange == null
                ? const Text('No range selected')
                : Text(
                    '${DateFormat('MM/dd/yyyy').format(selectedDateRange!.start)} - ${DateFormat('MM/dd/yyyy').format(selectedDateRange!.end)}'),
            onTap: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: selectedDateRange ??
                    DateTimeRange(
                        start: DateTime.now().subtract(const Duration(days: 7)),
                        end: DateTime.now()),
              );
              if (picked != null) {
                setState(() {
                  selectedDateRange = picked;
                });
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter by Date'),
            onPressed: () => openFilterDialog(context),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('passengers')
                .doc(passengerId)
                .collection('reservations')
                .orderBy('date_and_time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No reservations found.'));
              }

              final reservationDocs = snapshot.data!.docs.where((reservation) {
                // Apply Date Range Filter
                Timestamp date = reservation['date_and_time'];
                return filterByDate(date);
              }).toList();

              return ListView.builder(
                itemCount: reservationDocs.length,
                itemBuilder: (context, index) {
                  var reservation = reservationDocs[index];
                  Timestamp timestamp = reservation['date_and_time'];
                  DateTime currentdate = DateTime.now();
                  String today = DateFormat('yyyy-MM-dd').format(currentdate);
                  print(today);
                  String formattedDate = formatDate(timestamp);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${reservation['bus_company']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Php ${reservation['fare'].toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Date: $formattedDate'),
                          const SizedBox(height: 4),
                          Text(
                            'Destination: ${reservation['to'].toString().toUpperCase()}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ViewHistory(buscomp: reservation['bus_company'], busnum: reservation['busnumber'], date: reservation['date_and_time'].toDate(), distance: reservation['distance_traveled'], end: reservation['to'], start: reservation['from'], )));
                      // TicketView(
                      //       amount: reservation['fare'].toString(),
                      //       busnum: reservation['busnumber'],
                      //       companyname: reservation['bus_company'],
                      //       currentlocc: reservation['from'],
                      //       date: reservation['date_and_time'].toDate(),
                      //       distance: reservation['distance_traveled'],
                      //       destination: reservation['to'],
                      //       resnum: reservation['reservation_number'],
                      //       type: acctype.toString(),
                      //     )));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart'; // Assuming TextContent is defined here.

class BusSchedulesScreen extends StatefulWidget {
  BusSchedulesScreen({super.key});

  @override
  State<BusSchedulesScreen> createState() => _BusSchedulesScreenState();
}

class _BusSchedulesScreenState extends State<BusSchedulesScreen> {
  var searchcon = TextEditingController();
  List<Map<String, dynamic>> busSchedules = [];
  List<Map<String, dynamic>> filteredSchedules = [];

  @override
  void initState() {
    super.initState();
    fetchBusSchedules();
  }

  Future<void> fetchBusSchedules() async {
    try {
      QuerySnapshot companiesSnapshot = await FirebaseFirestore.instance.collection('companies').get();

      List<Map<String, dynamic>> schedules = [];

      for (var companyDoc in companiesSnapshot.docs) {
        String companyName = companyDoc['company_name'];
        CollectionReference busesRef = companyDoc.reference.collection('buses');
        QuerySnapshot busesSnapshot = await busesRef.get();

        for (var busDoc in busesSnapshot.docs) {
          var busData = busDoc.data() as Map<String, dynamic>;
          schedules.add({
            'route': '${busData['terminalloc']} ----> ${busData['destination']}',
            'departure_time': busData['departure_time'],
            'bus_number': busData['bus_number'],
            'company_name': companyName,
          });
        }
      }

      setState(() {
        busSchedules = schedules;
        filteredSchedules = schedules; // Initially, show all schedules
      });
    } catch (e) {
      print('Error fetching bus schedules: $e');
    }
  }

  // Filter bus schedules based on the search query
  void filterBusSchedules(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      // If the search query is empty, display all schedules
      results = busSchedules;
    } else {
      // Filter schedules by matching the query with the route, bus number, or company name
      results = busSchedules.where((schedule) {
        final route = schedule['route'].toLowerCase();
        final busNumber = schedule['bus_number'].toLowerCase();
        final companyName = schedule['company_name'].toLowerCase();
        final queryLower = query.toLowerCase();

        return route.contains(queryLower) ||
               busNumber.contains(queryLower) ||
               companyName.contains(queryLower);
      }).toList();
    }

    setState(() {
      filteredSchedules = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextContent(name: 'Schedules', fcolor: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('assets/images/buses/schedbus.png'),
              height: 100,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: searchcon,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: filterBusSchedules, // Filter as user types
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredSchedules.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.redAccent), // Header color
                        columns: [
                          DataColumn(
                            label: TextContent(
                              name: 'Route',
                              fcolor: Colors.white,
                              fontweight: FontWeight.bold,
                              fontsize: 16,
                            ),
                          ),
                          DataColumn(
                            label: TextContent(
                              name: 'Departure Time',
                              fcolor: Colors.white,
                              fontweight: FontWeight.bold,
                              fontsize: 16,
                            ),
                          ),
                          DataColumn(
                            label: TextContent(
                              name: 'Bus Number',
                              fcolor: Colors.white,
                              fontweight: FontWeight.bold,
                              fontsize: 16,
                            ),
                          ),
                          DataColumn(
                            label: TextContent(
                              name: 'Company',
                              fcolor: Colors.white,
                              fontweight: FontWeight.bold,
                              fontsize: 16,
                            ),
                          ),
                        ],
                        rows: filteredSchedules.map((schedule) {
                          return DataRow(
                            cells: [
                              DataCell(
                                TextContent(
                                  name: schedule['route'],
                                  fcolor: Colors.black,
                                  fontsize: 14,
                                ),
                              ),
                              DataCell(
                                TextContent(
                                  name: "${schedule['departure_time']} am",
                                  fcolor: Colors.black,
                                  fontsize: 14,
                                ),
                              ),
                              DataCell(
                                TextContent(
                                  name: schedule['bus_number'],
                                  fcolor: Colors.black,
                                  fontsize: 14,
                                ),
                              ),
                              DataCell(
                                TextContent(
                                  name: schedule['company_name'],
                                  fcolor: Colors.black,
                                  fontsize: 14,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        border: TableBorder.all(color: Colors.grey), // Add borders to the table
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

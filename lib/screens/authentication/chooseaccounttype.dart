// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/screens/authentication/idpic.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/idpic.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/accountypeconfirmed.dart';
// // import 'package:ilugan_passenger_mobile_app/screens/authentication/idverification.dart';
// // import 'package:ilugan_passenger_mobile_app/screens/authentication/signupscreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/screens/userscreens/accountypeconfirmed.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class PassengerTypeScreen extends StatefulWidget {
  @override
  _PassengerTypeScreenState createState() => _PassengerTypeScreenState();
}

class _PassengerTypeScreenState extends State<PassengerTypeScreen> {
  String selectedPassengerType = '';
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    requestpermission();
  }

  void requestpermission() async {
    NotificationSettings permission = await messaging.requestPermission();
    // if(permission.authorizationStatus == "")
    print('Permission Status: ${permission.authorizationStatus}');

  }

  void updateaccountdata() async {
    await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'type' : 'Regular'
    });
     Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const AcceptedAccountype()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: TextContent(
          name: 'Account Set Up',
          fontsize: 20,
          fcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.redAccent,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Image(
              image: AssetImage("assets/images/logo/logo.png"),
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextContent(
              name: 'What kind of passenger are you?',
              fontsize: 18,
              fontweight: FontWeight.bold,
            ),
            const Gap(50),
            // Passenger Type Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildPassengerTypeCard(
                      'Regular', Icons.person, 'Regular commuter'),
                  buildPassengerTypeCard(
                      'Student', Icons.school, 'Student commuter'),
                  buildPassengerTypeCard(
                      'PWD', Icons.accessible, 'Person with disability'),
                  buildPassengerTypeCard(
                      'Senior Citizen', Icons.elderly, 'Senior commuter'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedPassengerType.isNotEmpty) {
            // Go to next screen with selectedPassengerType
            if(selectedPassengerType != 'Regular'){
              print(selectedPassengerType);
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PhotoIdScreen(type: selectedPassengerType)));
            }else{
              print(selectedPassengerType);
              // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AcceptedAccountype()));
              updateaccountdata();
            }
          } else {
            // Show a message to select a passenger type
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a passenger type')),
            );
          }
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Widget to build passenger type card
  Widget buildPassengerTypeCard(
      String type, IconData icon, String description) {
    bool isSelected = selectedPassengerType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPassengerType = type;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.redAccent : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.redAccent : Colors.grey,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40, color: isSelected ? Colors.white : Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              type,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

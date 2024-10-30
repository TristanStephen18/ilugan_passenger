import 'package:flutter/material.dart';
import 'package:ilugan_passsenger/firebase_helpers/fetching.dart';
import 'package:ilugan_passsenger/screens/authentication/chooseaccounttype.dart';
import 'package:ilugan_passsenger/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/firebase_helpers/fetching.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/chooseaccounttype.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';

class TypeCheckerScreen extends StatefulWidget {
  const TypeCheckerScreen({super.key});

  @override
  State<TypeCheckerScreen> createState() => _TypeCheckerScreenState();
}

class _TypeCheckerScreenState extends State<TypeCheckerScreen> {

  String? type;

  @override
  void initState() {
    super.initState();
    gettype();
  }

  void gettype() async {
    String? response = await FetchingData().getacctype();

    setState(() {
      type = response;
    });
    print(type);
  }

  @override
  Widget build(BuildContext context) {
    return type == "" ? PassengerTypeScreen() : const HomeScreen();
  }
}
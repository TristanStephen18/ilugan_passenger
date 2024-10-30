import 'package:flutter/material.dart';
// import 'package:ilugan_passenger_mobile_app/api/apicalls.dart';

class ApiTry extends StatefulWidget {
  const ApiTry({super.key});

  @override
  State<ApiTry> createState() => _ApiTryState();
}

class _ApiTryState extends State<ApiTry> {

  List<String> municipalities = [];
  List<String> barangays = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(onPressed: ()async{
              // String? response = await ApiCalls().getCityCode('Luzon');
            }, child: const Text('Get Cities'))
          ],
        ),
      ),
    );
  }
}
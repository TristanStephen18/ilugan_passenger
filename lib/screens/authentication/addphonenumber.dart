// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class AddPhoneNumberScreen extends StatelessWidget {
   AddPhoneNumberScreen({super.key});

  var phonecon = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendOTP(){
    auth.verifyPhoneNumber(
      phoneNumber: '+63${phonecon.text}',
      verificationCompleted: (phoneAuthCredential) {
        
      }, 
      verificationFailed: (error) {
        print(error);
      }, 
      codeSent: (verificationId, forceResendingToken) {
        print('Code sent');
      }, 
      codeAutoRetrievalTimeout:(verificationId) {
        print('Auto Retrieval Timed out');
      }, 
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Column(
              children: [
                const Gap(70),
                TextContent(
                  name: 'Add a phone number',
                  fontsize: 20,
                  fontweight: FontWeight.bold,
                ),
                const Gap(10),
                TextContent(
                  name: 'Link a phone number to your Ilugan Account',
                  fontsize: 13,
                ),
                const Spacer(),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: TextContent(name: "Enter your phone number")),
                const Gap(10),
                PTfields(field_controller: phonecon, prefix: TextContent(name: '+63 | ') ,),
                const Spacer(),
                EButtons(
                  onPressed: sendOTP,
                  name: 'Send Code',
                  tcolor: const Color.fromARGB(255, 9, 49, 82),
                ),
                const Gap(20),
                // TextButton(
                //     onPressed: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (_) => PhoneVerificationSCreen()));
                //     },
                //     child: TextContent(
                //       name: 'Use Phone Number instead ->',
                //       fcolor: Colors.blue,
                //       fontsize: 18,
                //       fontweight: FontWeight.w800,
                //     )),
                const Spacer(),
              ],
            ),
          ),
      ),
    );
  }
}
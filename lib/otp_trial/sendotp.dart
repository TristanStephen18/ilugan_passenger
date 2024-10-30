// ignore_for_file: must_be_immutable

import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/emailverification.dart';

class SendOtp extends StatelessWidget {
  SendOtp({super.key});

  var otpcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Otp Trial'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(onPressed: () async {
              if(await EmailOTP.sendOTP(email: 'esupgaming101@gmail.com')){
                print('OTp Ssent');
                // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EmailVeficationScreen()));
              }else{
                print('Error sending otp');
              }
            }, child: const Text('Send otp')),
          ),
          const Gap(10),
          TextField(
            controller: otpcon,
          ),
          ElevatedButton(onPressed: (){
            if(EmailOTP.verifyOTP(otp: otpcon.text)){
              print('Otp is correct');
            }else{
              print('Otp is worng');
            }
          }, child: const Text('Verify Otp'))
        ],
      ),
    );
  }
}
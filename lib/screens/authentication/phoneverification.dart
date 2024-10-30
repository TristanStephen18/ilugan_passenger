// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:quickalert/quickalert.dart';

class PhoneVerificationSCreen extends StatelessWidget {
  const PhoneVerificationSCreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Verify your email'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const Gap(70),
              TextContent(name: 'Verify your phone number', fontsize: 20, fontweight: FontWeight.bold,),
              TextContent(name: 'A 6-digit code was sent to your +63928*******.', fontsize: 15,),
              TextContent(name: 'Enter the code to create your account'),
              const Spacer(),
              OtpTextField(
                fieldHeight: 80,
                fieldWidth: 46,
                borderRadius: BorderRadius.circular(10),
                numberOfFields: 6, 
                borderColor: const Color.fromARGB(255, 0, 0, 0), 
                showFieldAsBox: true, 
                enabledBorderColor: const Color.fromARGB(255, 0, 0, 0),
                enabled: true,
                fillColor: const Color.fromARGB(255, 184, 175, 175),
                filled: true,
                borderWidth: 2,
                onCodeChanged: (String code) {

                },
                onSubmit: (String verificationCode) {
                  if(!EmailOTP.verifyOTP(otp: verificationCode)){
                    QuickAlert.show(context: context, 
                    type: QuickAlertType.error,
                    text: 'The OTP you entered is incorerect',
                    title: 'Verification Error'
                    );
                  }else{
                    print('Wrong otp');
                  }
                  
                },
              ),
              const Spacer(),
              EButtons(onPressed: (){}, name: 'Resend Code', tcolor: const Color.fromARGB(255, 9, 49, 82),),
              const Spacer(),
            ],
          ),
        ));
  }
}

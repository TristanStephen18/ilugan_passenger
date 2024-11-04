// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/notifications/model.dart';
import 'package:ilugan_passsenger/screens/authentication/loginscreen.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/loginscreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/idverification.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:quickalert/quickalert.dart';

class EmailVeficationScreen extends StatefulWidget {
  EmailVeficationScreen(
      {super.key,
      required this.username,
      required this.email,
      required this.password,
      });

  String email;
  String password;
  String username;

  @override
  State<EmailVeficationScreen> createState() => _EmailVeficationScreenState();
}

class _EmailVeficationScreenState extends State<EmailVeficationScreen> {
  @override
  void initState() {
    super.initState();
    sendOTP();
    gettoken();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // void createaccount(BuildContext context)async
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmtoken;

  void gettoken() async {
    String? token = await messaging.getToken();
    if(token != null){
      setState(() {
        fcmtoken = token;
    });
    }else{
      print('Token not created');
    }
  }

  void createaccount(BuildContext context) async {
      try {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            text: "Creating account");
        UserCredential usercred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: widget.email, password: widget.password);

        String id = usercred.user!.uid;

        await FirebaseFirestore.instance.collection('passengers').doc(id).set({
          'username': widget.username,
          'email': widget.email,
          'password': widget.password,
          'hasphonenumber': false,
          'phonenumber': "",
          'bus' : "",
          'type': '',
        });

        // User? user = usercred.user;

        Navigator.of(context).pop();
        Notif().accountcreationnotification();
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            showConfirmBtn: true,
            onConfirmBtnTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            title: 'Account Created',
            text: 'You can now log in your account!');
      } on FirebaseAuthException catch (error) {
        Navigator.of(context).pop();
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "error",
            title: error.toString());
      }
  }

  void sendOTP() {
    EmailOTP.sendOTP(email: widget.email);
  }

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
              TextContent(
                name: 'Verify your email',
                fontsize: 20,
                fontweight: FontWeight.bold,
              ),
              TextContent(
                name: 'A 6-digit code was sent to ${widget.email}.',
                fontsize: 13,
              ),
              TextContent(name: 'Enter the code to verify your email'),
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
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  if (!EmailOTP.verifyOTP(otp: verificationCode)) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'The OTP you entered is incorerect',
                        title: 'Verification Error');
                  } else {
                    // print('Nice otp');
                    createaccount(context);
                  }
                },
              ),
              const Spacer(),
              EButtons(
                onPressed: sendOTP,
                name: 'Resend Code',
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
        ));
  }
}

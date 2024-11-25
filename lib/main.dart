import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ilugan_passsenger/notifications/model.dart';
import 'package:ilugan_passsenger/screens/index/splashscreen.dart';
// import 'package:ilugan_passsenger/trial/notificationstrial.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EmailOTP.config(
    appName: 'Ilugan',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
  );
  await Notif.initializenotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Ilugan());
}

class Ilugan extends StatelessWidget {
  const Ilugan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home: const ApiTry(),
      home:  const SplashScreen(),
    );
  }
}
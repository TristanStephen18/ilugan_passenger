import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:ilugan_passenger_mobile_app/screens/index/landingscreen2.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/typecheckerscreen.dart';
import 'package:ilugan_passsenger/screens/index/landingscreen2.dart';
import 'package:ilugan_passsenger/screens/userscreens/typecheckerscreen.dart';
// import 'package:gap/gap.dart';
// import 'package:ilugan_passenger_mobile_app/screens/index/landingscreen.dart';
// import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(255, 226, 46, 46),
      splash:  const Center(
        child: Image(
                    image: AssetImage(
                      "assets/images/logo/logo1.png",
                    ),
        ),
      ),
    splashIconSize: 300,
    nextScreen: FirebaseAuth.instance.currentUser == null ? LandingScreen2() : const TypeCheckerScreen());
  }
}
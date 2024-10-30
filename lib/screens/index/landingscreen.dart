import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/screens/authentication/loginscreen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 46, 46),
      body: Center(
        child: Column(
          children: [
            const Gap(50),
            Image(
              image: const AssetImage("assets/images/logo/logo.png"),
              width: MediaQuery.sizeOf(context).width / 2,
              height: 250,
            ),
            TextContent(name: 'Ilugan', fontsize: 40, fcolor: Colors.white,),
            TextContent(name: 'Your friendly bus acquaintance', fcolor: Colors.white, fontsize: 20,),
            const Spacer(),
            Buttons(
              onPressed: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => LoginScreen()));
              },
              name: "Get Started",
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/firebase_helpers/account.dart';
import 'package:ilugan_passsenger/notifications/model.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/chooseaccounttype.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/signupscreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/typecheckerscreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/screens/authentication/signupscreen.dart';
import 'package:ilugan_passsenger/screens/userscreens/typecheckerscreen.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Notif().requestNotificationPermissions(context);
  }

  final _auth = FirebaseAuth.instance;

  final formkey = GlobalKey<FormState>();

  var emailcon = TextEditingController();
  var passcon = TextEditingController();

  void checklogin() async {
    if (formkey.currentState!.validate()) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: "Logging you in",
          title: "ILugan");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailcon.text, password: passcon.text)
          .then((UserCredential cred) async {
        Account().setstatus(cred.user!.uid, 'login');
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const TypeCheckerScreen()));
      }).catchError((error) {
        Navigator.of(context).pop();
        print(error.code);
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: error.message.toString(),
            title: "Oooopppss");
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        title: TextContent(
          name: 'Log in',
          fontsize: 30,
          fcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.yellow,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo/logo.png"),
            height: 50,
            width: 50,
          ),
          Gap(10)
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.6,
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Spacer(),
                      TextContent(
                        name: "Welcome back! Kindly enter your",
                        fcolor: Colors.white,
                        fontsize: 16,
                      ),
                      TextContent(
                          name: "login details. ", fcolor: Colors.white),
                      const Gap(40),
                      TextContent(name: "Email", fcolor: Colors.white),
                      const Gap(5),
                      LoginTfields(
                        field_controller: emailcon,
                        suffixicon: Icons.mail_outline,
                      ),
                      const Gap(20),
                      TextContent(name: "Password", fcolor: Colors.white),
                      const Gap(5),
                      LoginPassTfields(
                        field_controller: passcon,
                        showpassIcon: Icons.visibility,
                        hidepassIcon: Icons.visibility_off,
                        showpass: true,
                      ),
                      const Gap(10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                if(emailcon.text == ""){
                                  QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'Pasword Reset',
                                          text:
                                              'Provide an email first');
                                }else{
                                  await _auth
                                    .sendPasswordResetEmail(
                                        email: emailcon.text)
                                    .then(
                                      (value) => QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.info,
                                          title: 'Pasword Reset',
                                          text:
                                              'A password reset link has been sent to ${emailcon.text}'),
                                    );
                                }
                              },
                              child: const Text(
                                'Forgot User Password?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SignUpScreen()));
                                },
                                child: TextContent(
                                  name: 'Dont have an account?',
                                  fcolor:
                                      const Color.fromARGB(255, 117, 190, 250),
                                )),
                          ],
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.35,
                  width: screenWidth,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 89),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 90),
                        child: EButtons(
                          onPressed: checklogin,
                          name: "Log In",
                          tcolor: Colors.white,
                          bcolor: Colors.redAccent,
                          elevation: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

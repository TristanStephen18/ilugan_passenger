// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';
// import 'package:ilugan_passenger_mobile_app/firebase_helpers/fetching.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/emailverification.dart';
// import 'package:ilugan_passenger_mobile_app/screens/authentication/loginscreen.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';

// class DiscountedSignUPScreen extends StatefulWidget {
//   DiscountedSignUPScreen({super.key, this.idimage, required this.acctype});

//   String acctype;
//   File? idimage;

//   @override
//   _DiscountedSignUPScreenState createState() => _DiscountedSignUPScreenState();
// }

// class _DiscountedSignUPScreenState extends State<DiscountedSignUPScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   // final TextEditingController _phoneController = TextEditingController();

//   bool _validatePasswords() {
//     return _passwordController.text == _confirmPasswordController.text;
//   }

//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       if (!_validatePasswords()) {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.error,
//           title: 'Passwords do not match',
//           text: 'Please re-enter your password',
//         );
//       } else {
//         uploadIdToStorage();
//         // Navigator.of(context).push(MaterialPageRoute(
//         //     builder: (_) => EmailVeficationScreen(
//         //         username: _usernameController.text,
//         //         email: _emailController.text,
//         //         password: _passwordController.text,
//         //         id: widget.idimage,
//         //         )));
//       }
//     }
//   }

//   void uploadIdToStorage() async {
//     if (widget.idimage != null) {
//       File file = widget.idimage!;
//       String path = 'idpictures/${file.path.split('/').last}';
//       final storageRef = FirebaseStorage.instance.ref().child(path);

//       UploadTask uploadTask = storageRef.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print(
//             'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
//       });

//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
//         print('File uploaded!');
//       });

//       String downloadURL = await taskSnapshot.ref.getDownloadURL();
//       print('Download URL: $downloadURL');

//       await FirebaseFirestore.instance
//           .collection('requests')
//           .doc(_emailController.text)
//           .set({
//         'username': _usernameController.text,
//         'email': _emailController.text,
//         'password': _passwordController.text,
//         'type': widget.acctype,
//         'imagelocation': downloadURL,
//         'accepted': false
//       });

//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (_) => EmailVeficationScreen(
//                 username: _usernameController.text,
//                 email: _emailController.text,
//                 password: _passwordController.text,
//                 id: widget.idimage,
//                 idurl: downloadURL,
//                 type: widget.acctype,
//               )));
//     } else {
//       print('No file selected');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.redAccent,
//       appBar: AppBar(
//         centerTitle: true,
//         toolbarHeight: 70,
//         title: TextContent(
//           name: 'Create Account',
//           fontsize: 20,
//           fcolor: Colors.white,
//           fontweight: FontWeight.w500,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.redAccent,
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 10.0),
//             child: Image(
//               image: AssetImage("assets/images/logo/logo.png"),
//               height: 50,
//               width: 50,
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         height: MediaQuery.sizeOf(context).height,
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image:
//                     AssetImage('assets/images/backgroundimages/signupbg.avif'),
//                 opacity: 0.8,
//                 alignment: Alignment.bottomCenter)),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(30.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextContent(
//                     name:
//                         "Create your ILugan Account and start your adventure!",
//                     fontsize: 17,
//                     fontweight: FontWeight.bold,
//                   ),
//                   const Gap(3),
//                   TextContent(name: "Please fill in the following"),
//                   const Gap(40),
//                   TextContent(name: "Create a username"),
//                   const Gap(5),
//                   Tfields(
//                     field_controller: _usernameController,
//                     suffixicon: Icons.person,
//                   ),
//                   const Gap(10),
//                   TextContent(name: "Email"),
//                   const Gap(5),
//                   Tfields(
//                     field_controller: _emailController,
//                     suffixicon: Icons.mail_outline,
//                   ),
//                   const Gap(10),
//                   TextContent(name: "Create Password"),
//                   const Gap(5),
//                   Password_Tfields(
//                     field_controller: _passwordController,
//                     showpassIcon: Icons.visibility,
//                     hidepassIcon: Icons.visibility_off,
//                     showpass: true,
//                   ),
//                   const Gap(10),
//                   TextContent(name: "Confirm Password"),
//                   const Gap(5),
//                   Password_Tfields(
//                     field_controller: _confirmPasswordController,
//                     showpassIcon: Icons.visibility,
//                     hidepassIcon: Icons.visibility_off,
//                     showpass: true,
//                   ),
//                   const Gap(60),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: EButtons(
//                       onPressed: _submit,
//                       name: "Create Account",
//                       bcolor: Colors.red,
//                       tcolor: Colors.white,
//                       elevation: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class AdminVerification extends StatefulWidget {
  AdminVerification(
      {super.key,
      required this.idimage,
      required this.type,
      });

  File idimage;
  String type;


  @override
  State<AdminVerification> createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<AdminVerification> {
  @override
  void initState() {
    super.initState();
    isAccepted(FirebaseAuth.instance.currentUser!.email.toString());
  }

  void isAccepted(String email) {
  FirebaseFirestore.instance
      .collection('requests')
      .doc(email)
      .snapshots()
      .listen((DocumentSnapshot snapshots) async {
    print('Firestore listener triggered');  // Debug print
    print(email);

    if (snapshots.exists) {
      print('Document exists');  // Debug print
      var data = snapshots.data() as Map<String, dynamic>;
      bool status = data['accepted'];
      String imagelocation = data['imagelocation'];
      print('isaccepted value: $status');  // Debug print for isaccepted

      if (status) {
        await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'id' : imagelocation
        });

      }
    } else {
      print('Document does not exist');  // Debug print
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: TextContent(
          name: 'ID Verification',
          fontsize: 18,
          fcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                widget.idimage,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          const Gap(20),
          TextContent(
            name: 'Admin is verifying your ID...',
            fontsize: 30,
            fontweight: FontWeight.bold,
          ),
          const Gap(100),
          const Spacer()
        ],
      ),
    );
  }
}

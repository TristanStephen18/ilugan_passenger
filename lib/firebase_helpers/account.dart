import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Account {
  void createaccount(String email, String password, String idloc, String type, String username) async {
   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((user) async {
        await FirebaseFirestore.instance.collection('passengers').doc(user.user!.uid).set({
          'username': username,
          'email': email,
          'password': password,
          'hasphonenumber': false,
          'phonenumber': "",
          'type': type,
          'id' : idloc
        });
    }).catchError((error){
      // QuickAlert.show(context: , type: type)
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class FetchingData {
  Future<String?> getacctype() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('passengers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      return doc['type'] as String?;
    } else {
      return null; 
    }
  }

  Future<String?> getemail() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('passengers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      return doc['email'] as String?;
    } else {
      return null; 
    }
  }

  void isAccepted(String email){
    FirebaseFirestore.instance
        .collection('request')
        .doc(email)
        .snapshots().listen((DocumentSnapshot snapshots){
          if(snapshots.exists){
           var data = snapshots.data() as Map<String, dynamic>;
           bool status = data['isaccepted'];

           if(status){
            print(status);
           }
          }else{
            print('Error fetching data');
          }
        });
  }

  Future<String?> getUSerToken() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if(snapshot.exists){
      var data = snapshot.data() as Map<String, dynamic>;

      return data['token'];  
    }
    return null;
    // return null;
  }

  Future<String?> getidurl()async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('passengers').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if(snapshot.exists){
      var data = snapshot.data() as Map<String, dynamic>;

      return data['id'];  
    }
    return null;

    // return null;
  }
}

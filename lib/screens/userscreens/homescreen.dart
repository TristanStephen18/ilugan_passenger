// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/firebase_helpers/account.dart';
import 'package:ilugan_passsenger/monitoring/reservation_monitoring.dart';
import 'package:ilugan_passsenger/screens/index/landingscreen2.dart';
import 'package:ilugan_passsenger/screens/userscreens/notification.dart';
import 'package:ilugan_passsenger/widgets/classes.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<QuerySnapshot> _busSubscription;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _userSubscription;
  late StreamSubscription<Position> _positionSubscription;

  LatLng myloc = const LatLng(120.56463553247369, 120.56463553247369);
  String username = "";
  String email = "";
  bool hasreservation = false;
  BitmapDescriptor busmarkers = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {};
  late GoogleMapController mapController;
  String? hronbusnum;

  @override
  void initState() {
    super.initState();
    getemailandusername();
    getCurrentLocation();
    customIconforMovingBuses();
    fetchBusesForCompany();
  }

  @override
  void dispose() {
    _busSubscription.cancel();
    _userSubscription.cancel();
    _positionSubscription.cancel();
    super.dispose();
  }

  void fetchBusesForCompany() {
    String companyId = '1CzPhECXc8PFJQP4rfGzwW77gKp1';
    _busSubscription = FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('buses')
        .snapshots()
        .listen((busSnapshot) async {
      for (var busDoc in busSnapshot.docs) {
        if (!mounted) return; // Check if widget is mounted

        var busData = busDoc.data();
        String busNumber = busData['bus_number'] ?? '';

        String plateNumber = busData['plate_number'] ?? '';
        int availableSeats = busData['available_seats'] ?? 0;
        int occupiedSeats = busData['occupied_seats'] ?? 0;
        int reservedSeats = busData['reserved_seats'] ?? 0;
        String from = busData['terminalloc'] ?? 'Dagupan';
        String to = busData['destination'] ?? 'Cubao';
        GeoPoint geoPoint = busData['current_location'] ?? const GeoPoint(0, 0);
         GeoPoint geoPointd = busData['destination_coordinates'] ?? const GeoPoint(0, 0);
        LatLng currentLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
        LatLng destinationLocation = LatLng(geoPointd.latitude, geoPointd.longitude);
        String via = busData['via'] ?? 'McArthur Highway'; 
        String bustype = busData['bustype'];

        String address = await ApiCalls()
            .reverseGeocode(currentLocation.latitude, currentLocation.longitude);

        if(hronbusnum != null && hronbusnum == plateNumber && reservationnumber != null){
          print('Bus Found');
          print('$hronbusnum is $plateNumber');
          print(reservationnumber);
          BusMonitoring().listentobuslocation(companyId, plateNumber, reservationnumber.toString());
          // BusMonitoring().getFirstReservation();
        }

        if (!mounted) return; // Check again after async operation

        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(busNumber),
              position: currentLocation,
              onTap: () {
                DisplayItems().showBusInfoDialog(
                    context,
                    'Dagupan Bus Inc.',
                    busNumber,
                    plateNumber,
                    address,
                    availableSeats,
                    occupiedSeats,
                    reservedSeats,
                    companyId,
                    myloc,
                    hasreservation,
                    destinationLocation,
                    currentLocation,
                    from,
                    to,
                    via,
                    bustype,
                );
              },
              icon: busmarkers,
            ),
          );
        });
      }
    }, onError: (e) {
      print('Error fetching buses: $e');
    });
  }

  String? reservationnumber;

  void getemailandusername() {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    _userSubscription = FirebaseFirestore.instance
        .collection('passengers')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return; // Check if widget is mounted

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          email = data['email'];
          username = data['username'];
          hasreservation = data['hasreservation'];
          hronbusnum = data['busnum'];
          reservationnumber = data['current_reservation'];
        });
        if(hasreservation == true && hronbusnum != ""){
          print("waiting for bus");
          // ApiCalls().getDistance(, );
        }
        print(hronbusnum);
      } else {
        print("Document does not exist");
      }
    });
  }

  void customIconforMovingBuses() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(2, 2),
        devicePixelRatio: 1,
      ),
      "assets/icons/mbus.bmp",
    ).then((icon) {
      if (!mounted) return; // Check if widget is mounted
      setState(() {
        busmarkers = icon;
      });
    }).catchError((error) {
      print("Error loading custom icon: $error");
    });
  }

  void getCurrentLocation() async {
    if (!await checkServicePermission()) return;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((position) {
      if (!mounted) return; // Check if widget is mounted
      myloc = LatLng(position.latitude, position.longitude);
      setToLocation(myloc);
      if(hasreservation == true && hronbusnum != null){
        print('Waiting for bus arrival');
      }
    });
  }

  void setToLocation(LatLng position) {
    if (!mounted) return; // Check if widget is mounted
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<bool> checkServicePermission() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      return false;
    }
    return true;
  }

  void logout() async {
    Account().setstatus(FirebaseAuth.instance.currentUser!.uid, 'logout');
    await FirebaseAuth.instance.signOut();
    // Account().setstatus(Fireba, option)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LandingScreen2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(
          logoutfunc: logout,
          username: username,
          email: email,
        ),
        appBar: AppBar(
          title: Row(
            children: [
              TextContent(
                name: 'ILugan',
                fcolor: Colors.white,
              ),
              const Image(
                image: AssetImage("assets/images/logo/logo.png"),
                height: 32,
                width: 32,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => NotificationsPage()));
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ))
          ],
        ),
        body: SafeArea(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(15.975949534874196, 120.57135500752592),
                zoom: 15),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }
}

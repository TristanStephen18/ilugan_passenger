// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ilugan_passenger_mobile_app/api/apicalls.dart';
// import 'package:ilugan_passenger_mobile_app/screens/reservation/reservation.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/reservation.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class SelectLocationScreen extends StatefulWidget {
  SelectLocationScreen(
      {super.key,
      required this.companyId,
      required this.compName,
      required this.busnum,
      required this.currentloc,
      required this.destinationloc,
      required this.currentlocation});

  String companyId;
  String compName;
  String busnum;
  LatLng currentloc;
  LatLng destinationloc;
  LatLng currentlocation;

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? selectedLocation; // Variable to store selected LatLng
  LatLng? locationCoordinates;
  late GoogleMapController mapController;
  String address = "";
  final TextEditingController _searchController =
      TextEditingController(); // Controller for the search input
  bool isLoading = false; // Loading state for search
  String? polylinecode;
  Map<PolylineId, Polyline> _polylines = {};
  Set<Marker> _markers = {}; // Set to store markers
  List<LatLng> polylinePoints = []; 
  PolylinePoints polylinePoint = PolylinePoints();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => await initializemap());
      getPolylinesCode();
  }

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(15.9759, 120.5713), // Example coordinates
    zoom: 12,
  );

  Future<void> initializemap() async {
    // Add markers for the current location (bus starting point) and destination
    _addMarker(widget.currentlocation, "Current Location",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
    _addMarker(widget.destinationloc, "Destination",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
  }

  // Function to handle map tap and store the selected LatLng
  Future<void> getPolylinesCode() async {
    polylinecode = await ApiCalls()
        .fetchPolyline(widget.currentlocation, widget.destinationloc);
    if (polylinecode != null) {
      polylinePoints = decodePolyline(polylinecode!);
    }
  }

  // Decode polyline to a list of LatLng points
  List<LatLng> decodePolyline(String polyline) {
    // Decode logic to transform polyline string to list of LatLng points
    List<PointLatLng> decodedPoints = polylinePoint.decodePolyline(polyline);
    return decodedPoints.map((point) => LatLng(point.latitude, point.longitude)).toList();
  }

  // Check if selected location is near polyline route
  bool isLocationNearPolyline(LatLng location, double thresholdMeters) {
    for (LatLng point in polylinePoints) {
      double distance = calculateDistance(location, point);
      if (distance < thresholdMeters) return true;
    }
    return false;
  }

  // Haversine formula to calculate distance between two points
  double calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371000; // in meters
    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLng = _toRadians(point2.longitude - point1.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
              cos(_toRadians(point1.latitude)) * cos(_toRadians(point2.latitude)) *
              sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  void _onMapTapped(LatLng position) async {
    setState(() => selectedLocation = position);
    bool isValid = isLocationNearPolyline(position, 100); // Check if within 100m of route

    if (isValid) {
      // Valid location selected, add marker and update address
      String fetchedAddress = await ApiCalls().reverseGeocode(position.latitude, position.longitude);
      setState(() {
        address = fetchedAddress;
      });
      _addMarker(position, "Selected Location", BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
    } else {
      // Show "Invalid Location" message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid location: too far from the route")),
      );
    }
  }

  // Future<List<LatLng>> getPolylinepoints() async {
  //   const String googlemapapikey = "AIzaSyBFTetVk2_X4bi6bMsEn9t5qGll7DfW8Mc";
  //   print("Adding Polyline");
  //   final result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleApiKey: googlemapapikey,
  //     request: PolylineRequest(
  //       origin: PointLatLng(
  //           widget.currentlocation.latitude, widget.currentlocation.longitude),
  //       destination: PointLatLng(
  //           widget.destinationloc.latitude, widget.destinationloc.longitude),
  //       mode: TravelMode.driving,
  //     ),
  //   );

  //   List<LatLng> polylineCoordinates = result.points
  //       .map((point) => LatLng(point.latitude, point.longitude))
  //       .toList();

  //   if (result.points.isNotEmpty) {
  //     return polylineCoordinates;
  //   } else {
  //     debugPrint(result.errorMessage);
  //     return [];
  //   }
  // }

  // Function to search for an address and update the map
  Future<void> _searchLocation() async {
    String searchText = _searchController.text.trim();
    if (searchText.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    LatLng? coordinates = await ApiCalls().getCoordinates(searchText);

    setState(() {
      isLoading = false;
    });

    if (coordinates != null) {
      setToLocation(coordinates);
      _onMapTapped(coordinates);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address not found")),
      );
    }
  }

  // Method to update the camera position
  void setToLocation(LatLng position) {
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      locationCoordinates = position;
    });
    print(locationCoordinates);
  }

  // Function to add markers on the map
  void _addMarker(LatLng position, String markerId, BitmapDescriptor icon) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: icon,
    );
    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextContent(name: "Select Destination", fcolor: Colors.white),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              mapController = controller;
              getPolylinesCode();
            },
            polylines: Set<Polyline>.of(_polylines.values),
            onTap: _onMapTapped,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _markers,
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 226, 220, 220),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextContent(
                      name: 'Selected Destination',
                      fontsize: 20,
                      fontweight: FontWeight.w700,
                    ),
                    const Spacer(),
                    address.isEmpty
                        ? const CircularProgressIndicator()
                        : TextContent(name: address),
                    const Spacer(),
                    EButtons(
                      onPressed: () {
                        print('Executed');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SeatReservationScreen(
                                  companyId: widget.companyId,
                                  companyname: widget.compName,
                                  busnum: widget.busnum,
                                  mylocation: widget.currentloc,
                                  destination: address,
                                  destinationcoordinates: locationCoordinates!,
                                )));
                      },
                      name: 'Confirm',
                      bcolor: Colors.blueAccent,
                      tcolor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          // Search Bar
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for a location...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

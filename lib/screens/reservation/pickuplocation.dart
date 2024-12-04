// ignore_for_file: must_be_immutable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ilugan_passsenger/api/apicalls.dart';
import 'package:ilugan_passsenger/screens/reservation/selectdestination.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class SelectPickUpLocationScreen extends StatefulWidget {
  SelectPickUpLocationScreen({
    super.key,
    required this.companyId,
    required this.compName,
    required this.busnum,
    required this.via,
    required this.seatQuantity,
    required this.bustype
  });

  final String companyId;
  final String compName;
  final String busnum;
  final String via;
  final int seatQuantity;
  final String bustype;

  @override
  _SelectPickUpLocationScreenState createState() =>
      _SelectPickUpLocationScreenState();
}

class _SelectPickUpLocationScreenState
    extends State<SelectPickUpLocationScreen> {
  LatLng? selectedLocation;
  LatLng? locationCoordinates;
  late GoogleMapController mapController;
  String address = "";
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  final Map<PolylineId, Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
    listentobuschosen(); // Listen to changes in real-time.
  }

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(15.9759, 120.5713), // Example coordinates
    zoom: 12,
  );

  Future<void> initializeMap() async {
    // Initialization logic can be added if required
  }

  void listentobuschosen() {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.companyId)
        .collection('buses')
        .doc(widget.busnum)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        final currentLocation = data['current_location'] as GeoPoint?;
        final destinationCoordinates = data['destination_coordinates'] as GeoPoint?;

        if (currentLocation != null) {
          final currentLatLng =
              LatLng(currentLocation.latitude, currentLocation.longitude);
          _updateMarker(currentLatLng, "Current Location",
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
        }

        if (destinationCoordinates != null) {
          final destinationLatLng = LatLng(
              destinationCoordinates.latitude, destinationCoordinates.longitude);
          _updateMarker(destinationLatLng, "Destination",
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        }
      } else {
        print("No data available for the bus.");
      }
    });
  }

  void _updateMarker(LatLng position, String markerId, BitmapDescriptor icon) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: icon,
    );
    setState(() {
      _markers
        ..removeWhere((m) => m.markerId.value == markerId)
        ..add(marker);
    });
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      selectedLocation = position;
    });
    String fetchedAddress =
        await ApiCalls().reverseGeocode(position.latitude, position.longitude);
    print(fetchedAddress);
    setToLocation(position);
    setState(() {
      address = fetchedAddress;
    });
    _updateMarker(position, "Selected Location",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
  }

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

  void setToLocation(LatLng position) {
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      locationCoordinates = position;
    });
    print(locationCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextContent(name: 'VIA: ${widget.via}', fcolor: Colors.white),
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
                      name: 'Pick Up Location',
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SelectLocationScreen(companyId: widget.companyId, compName: widget.compName, busnum: widget.busnum, pickupaddress: address, pickupcoordinates: locationCoordinates as LatLng, seatQuantity: widget.seatQuantity, bustype: widget.bustype,)));
                      },
                      name: 'Confirm',
                      bcolor: Colors.blueAccent,
                      tcolor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
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

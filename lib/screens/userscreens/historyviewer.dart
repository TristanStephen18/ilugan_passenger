  import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:ilugan_passsenger/api/apicalls.dart';
  import 'package:ilugan_passsenger/widgets/widgets.dart';
  import 'package:intl/intl.dart';

  class ViewHistory extends StatefulWidget {
    const ViewHistory({
      super.key,
      required this.start,
      required this.end,
      required this.busnum,
      required this.buscomp,
      required this.distance,
      required this.date,
    });

    final String start;
    final String end;
    final String busnum;
    final String buscomp;
    final String distance;
    final DateTime date;

    @override
    State<ViewHistory> createState() => _ViewHistoryState();
  }

  class _ViewHistoryState extends State<ViewHistory> {
    CameraPosition? initialpos;
    Set<Marker> markers = {};
    bool isloading = true;
    String date = "";
    LatLng? from;
    LatLng? to;
    

    @override
    void initState() {
      super.initState();
      initializedata();
    }

    void initializedata() async {
      LatLng? start = await ApiCalls().getCoordinates(widget.start);
      LatLng? end = await ApiCalls().getCoordinates(widget.end);

      if (start != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: start,
            infoWindow: const InfoWindow(title: "Pick up location"),
          ),
        );
      }
      if (end != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: end,
            infoWindow: const InfoWindow(title: "Destination"),
          ),
        );
      }


      String formatteddate = DateFormat.yMMMMd('en_US').format(widget.date);

      setState(() {
        isloading = false;
        date = formatteddate;
        initialpos = CameraPosition(target: start as LatLng, zoom: 11);
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: TextContent(name: "Travel History", fcolor: Colors.white),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: initialpos as CameraPosition,
                    markers: markers,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              TextContent(
                                name: 'Date and Time: $date',
                                fontsize: 12,
                              ),
                              TextContent(name: 'Distance Traveled: ${widget.distance}'),
                              const Image(
                                image: AssetImage('assets/icons/dagupan_bus.png'),
                                height: 80,
                              ),
                              TextContent(name: widget.buscomp),
                              TextContent(
                                name: widget.busnum,
                                fontsize: 18,
                                fontweight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const Gap(20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(20),
                                TextContent(name: 'From:', fontsize: 15, fontweight: FontWeight.bold,),
                               TextContent(name : widget.start.toUpperCase(),),
                                TextContent(name: 'To:', fontsize: 15, fontweight: FontWeight.bold,),
                                TextContent(name: widget.end.toUpperCase(),), 
                              ],
                            ),
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

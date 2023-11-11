import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kop_checkin/api/api.dart';
import 'package:kop_checkin/homescreen.dart';
import 'package:kop_checkin/location10.dart';
import 'package:kop_checkin/location2.dart';
import 'package:kop_checkin/location4.dart';
import 'package:kop_checkin/location5.dart';
import 'package:kop_checkin/location6.dart';
import 'package:kop_checkin/location7.dart';
import 'package:kop_checkin/location8.dart';
import 'package:kop_checkin/location9.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Location3 extends StatefulWidget {
  const Location3({super.key});

  @override
  State<Location3> createState() => _Location3State();
}

class _Location3State extends State<Location3> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn2 = '';

  String checkIn = '--/--';
  String checkOut = '--/--';
  String locationCheckin = " ";
  String locationCheckout = " ";
  Color primary = const Color.fromRGBO(12, 45, 92, 1);
  bool check = false;
  late Position currentLocation;

  final List<Marker> _list = [
    Marker(
        markerId: const MarkerId('1'),
        position: LatLng(Users.lat, Users.long),
        infoWindow: const InfoWindow(title: 'You are Here !'))
  ];

  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _maker = [];

  List<String> locationPage = [
    "location 1",
    "location 2",
    "location 3",
    "location 4",
    "location 5",
    "location 6",
    "location 7",
    "location 8",
    "location 9",
    "location 10",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _maker.addAll(_list);
    _getRecord();

  
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location service are Disable');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissino are denied, we cannot request');
    }

    return Geolocator.getCurrentPosition();
  }

  Future addRecordDetails(String locationCheckin) async {
    await http.post(Uri.parse(API.addCheckin), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'time': DateFormat('hh:mm a').format(DateTime.now()),
      'checkin_out': 'IN',
      'location': locationCheckin.toString(),
      'location_index': '3',
      'timestamp': DateFormat('yyyy-MM-dd').format(DateTime.now())
    });
  }

  Future updateRecordDetails(String locationCheckout) async {
    await http.post(Uri.parse(API.updateCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'time': DateFormat('hh:mm a').format(DateTime.now()),
      'location': locationCheckout.toString(),
      'location_index': '3',
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreeen()),
    );
  }

  void _getRecord() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '3',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        setState(() {
          checkIn = resBody['checkin'];
          checkOut = resBody['checkout'];
        });
      //  if (checkOut != '--/--') {
      //     setState(() {
      //       Users.checkout3 = true;
      //     });
      //   } else {
      //     setState(() {
      //       Users.checkout3 = false;
      //     });
      //   }
      } catch (e) {
        // setState(() {
        //   checkIn = '--/--';
        //   checkOut = '--/--';
        // });
        // setState(() {
        //   Users.checkout3 = false;
        // });
      }
    }
  }

  Future _goToMe(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
    )));
    _maker.add(
      Marker(
        markerId: const MarkerId('2'),
        position: LatLng(lat, long),
        infoWindow: const InfoWindow(
            title: 'My Current Position', snippet: 'ที่อยุ๋ปัจจุบัน'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String dropdownValue = 'location 3';
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                'Location 3',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 20),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      Users.username,
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     alignment: Alignment.center,
                //     child: DropdownMenu<String>(
                //       label: const Text('Location'),
                //       textStyle: const TextStyle(
                //         fontSize: 20,
                //         color: Colors.black54,
                //         fontFamily: 'NexaBold',
                //       ),
                //       initialSelection: dropdownValue,
                //       dropdownMenuEntries: locationPage
                //           .map<DropdownMenuEntry<String>>((String value) {
                //         return DropdownMenuEntry<String>(
                //             value: value, label: value);
                //       }).toList(),
                //       onSelected: (String? value) {
                //         setState(() {
                //           dropdownValue = value!;
                //         });
                //         // This is called when the user selects an item.
                //         if (dropdownValue == 'location 1') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const HomeScreeen()),
                //           );
                //         } else if (dropdownValue == 'location 2') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location2()),
                //           );
                //         } else if (dropdownValue == 'location 3') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location3()),
                //           );
                //         } else if (dropdownValue == 'location 4') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location4()),
                //           );
                //         } else if (dropdownValue == 'location 5') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location5()),
                //           );
                //         } else if (dropdownValue == 'location 6') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location6()),
                //           );
                //         } else if (dropdownValue == 'location 7') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location7()),
                //           );
                //         } else if (dropdownValue == 'location 8') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location8()),
                //           );
                //         } else if (dropdownValue == 'location 9') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location9()),
                //           );
                //         } else if (dropdownValue == 'location 10') {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Location10()),
                //           );
                //         }
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 20),
              ),
            ),
            Container(
              width: 400,
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(Users.lat, Users.long),
                  zoom: 17,
                ),
                markers: Set<Marker>.of(_maker),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 30),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2))
                ],
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                                fontFamily: 'NexaRegular',
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(checkIn,
                              style: TextStyle(
                                  fontFamily: 'NexaBold',
                                  fontSize: screenWidth / 18,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                                fontFamily: 'NexaRegular',
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(checkOut,
                              style: TextStyle(
                                  fontFamily: 'NexaBold',
                                  fontSize: screenWidth / 18,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: 'NexaBold',
                      ),
                      children: [
                        TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                              fontFamily: 'NexaBold',
                              fontSize: screenWidth / 20,
                              color: Colors.black54),
                        )
                      ]),
                )),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18,
                          color: Colors.black54),
                    ),
                  );
                }),
            if (checkOut == '--/--')
             Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 24),
                          child: MaterialButton(
                            onPressed: () {
                              _getCurrentLocation().then((value) {
                                setState(() {
                                  Users.lat = value.latitude;
                                  Users.long = value.longitude;
                                });
                              });
                              _goToMe(Users.lat, Users.long);
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.location_on_outlined,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      checkIn == '--/--'
                          ? Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: MaterialButton(
                                  onPressed: () async {
                                    _getCurrentLocation().then((value) {
                                  setState(() {
                                    Users.lat = value.latitude;
                                    Users.long = value.longitude;
                                  });
                                });
                                _goToMe(Users.lat, Users.long);
                                    List<Placemark> placemark =
                                        await placemarkFromCoordinates(
                                            Users.lat, Users.long);
                                    setState(() {
                                      locationCheckin =
                                          "${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].thoroughfare} ${placemark[0].subAdministrativeArea}  ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].postalCode}  ${placemark[0].country}";
                                    });
                                    setState(() {
                                      checkIn = DateFormat('hh:mm')
                                          .format(DateTime.now());
                                    });

                                    addRecordDetails(locationCheckin);
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.check_circle_outlined,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: MaterialButton(
                                  onPressed: () async {
                                    _getCurrentLocation().then((value) {
                                  setState(() {
                                    Users.lat = value.latitude;
                                    Users.long = value.longitude;
                                  });
                                });
                                _goToMe(Users.lat, Users.long);
                                    List<Placemark> placemark =
                                        await placemarkFromCoordinates(
                                            Users.lat, Users.long);
                                    setState(() {
                                      locationCheckout =
                                          "${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].thoroughfare} ${placemark[0].subAdministrativeArea}  ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].postalCode}  ${placemark[0].country}";
                                    });

                                    setState(() {
                                      checkOut = DateFormat('hh:mm')
                                          .format(DateTime.now());
                                    });
                                     setState(() {
                                      Users.checkout3 = true;
                                    });
                                    updateRecordDetails(locationCheckout);
                                  },
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )
                    ],
                  )
            else
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Text(
                  'Today You have Check In',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
          ],
        ),
      ),
   
    );
  }
}

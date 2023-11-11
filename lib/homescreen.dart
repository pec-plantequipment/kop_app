import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kop_checkin/api/api.dart';
import 'package:kop_checkin/calendar.dart';
import 'package:kop_checkin/checkinscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kop_checkin/location10.dart';
import 'package:kop_checkin/location2.dart';
import 'package:kop_checkin/location3.dart';
import 'package:kop_checkin/location4.dart';
import 'package:kop_checkin/location5.dart';
import 'package:kop_checkin/location6.dart';
import 'package:kop_checkin/location7.dart';
import 'package:kop_checkin/location8.dart';
import 'package:kop_checkin/location9.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:kop_checkin/profile.dart';
import 'package:kop_checkin/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecord1();
    _getRecord2();
    _getRecord3();
    _getRecord4();
    _getRecord5();
    _getRecord6();
    _getRecord7();
    _getRecord8();
    _getRecord9();
    _getRecord10();
  }

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color.fromRGBO(12, 45, 92, 1);
  int currerntIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarDay,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

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

  void changePage(int newIndex) {
    setState(() {
      currerntIndex = newIndex;
    });
  }

  void _startLocationService() async {
    LocationService().initialize();
    LocationService().getLatetude().then((value) {
      setState(() {
        Users.lat = value!;
      });
      LocationService().getLongtetude().then((value) {
        setState(() {
          Users.long = value!;
        });
      });
    });
  }

  void _getRecord1() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '1',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout1 = true;
          });
        } else {
          setState(() {
            Users.checkout1 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout1 = false;
        });
      }
    }
  }

  void _getRecord2() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '2',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout2 = true;
          });
        } else {
          setState(() {
            Users.checkout2 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout2 = false;
        });
      }
    }
  }

  void _getRecord3() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '3',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout3 = true;
          });
        } else {
          setState(() {
            Users.checkout3 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout3 = false;
        });
      }
    }
  }

  void _getRecord4() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '4',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout4 = true;
          });
        } else {
          setState(() {
            Users.checkout4 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout4 = false;
        });
      }
    }
  }

  void _getRecord5() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '5',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
         if (resBody['success'] == true) {
          setState(() {
            Users.checkout5 = true;
          });
        } else {
          setState(() {
            Users.checkout5 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout5 = false;
        });
      }
    }
  }

  void _getRecord6() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '6',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
       if (resBody['success'] == true) {
          setState(() {
            Users.checkout6 = true;
          });
        } else {
          setState(() {
            Users.checkout6 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout6 = false;
        });
      }
    }
  }

  void _getRecord7() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '7',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout7 = true;
          });
        } else {
          setState(() {
            Users.checkout7 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout7 = false;
        });
      }
    }
  }

  void _getRecord8() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '8',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
         if (resBody['success'] == true) {
          setState(() {
            Users.checkout8 = true;
          });
        } else {
          setState(() {
            Users.checkout8 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout8 = false;
        });
      }
    }
  }

  void _getRecord9() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '9',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          setState(() {
            Users.checkout9 = true;
          });
        } else {
          setState(() {
            Users.checkout9 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout9 = false;
        });
      }
    }
  }

  void _getRecord10() async {
    var res = await http.post(Uri.parse(API.getDocCheck), body: {
      'doc_date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'user_code': Users.id,
      'location_index': '10',
    });
    if (res.statusCode == 200) {
      try {
        var resBody = jsonDecode(res.body);
          if (resBody['success'] == true) {
          setState(() {
            Users.checkout10 = true;
          });
        } else {
          setState(() {
            Users.checkout10 = false;
          });
        }
      } catch (e) {
        setState(() {
          Users.checkout10 = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
 
    return Scaffold(
      body: IndexedStack(
        index: currerntIndex,
        children: [
          new CalendarScreen(),
          if (!Users.checkout1)
            new CheckinScreen()
          else if (!Users.checkout2)
            Location2()
          else if (!Users.checkout3)
            Location3()
          else if (!Users.checkout4)
            Location4()
          else if (!Users.checkout5)
            Location5()
          else if (!Users.checkout6)
            Location6()
          else if (!Users.checkout7)
            Location7()
          else if (!Users.checkout8)
            Location8()
          else if (!Users.checkout9)
            Location9()
          else
            Location10(),
          new ProflieScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      changePage(i);
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currerntIndex ? primary : Colors.black54,
                              size: i == currerntIndex ? 30 : 26,
                            ),
                            i == currerntIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    height: 3,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Perform cleanup when the widget is removed from the tree.
    super.dispose();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kop_checkin/api/api.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color.fromRGBO(12, 45, 92, 1);

  String _month = DateFormat('MMMM').format(DateTime.now());
  String _day = DateFormat('dd MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getRowCheckin() async {
    var res = await http.post(Uri.parse(API.getRowCheck), body: {
      'user_code': Users.id,
    });
    try {
      return jsonDecode(res.body);
    } catch (e) {}
  }

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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String dropdownValue = locationPage.first;
    return Users.id != ""
        ? Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "My Attendance",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'NexaBold',
                                fontSize: screenWidth / 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          _day,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'NexaBold',
                              fontSize: screenWidth / 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            int nowyear = DateTime.now().year.toInt();
                            final month = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(nowyear),
                              lastDate: DateTime(2099),
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: primary,
                                            secondary: primary,
                                            onSecondary: Colors.white),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                              primary: primary),
                                        ),
                                        textTheme: const TextTheme(
                                          headline4:
                                              TextStyle(fontFamily: 'NexaBold'),
                                          overline:
                                              TextStyle(fontFamily: 'NexaBold'),
                                          button:
                                              TextStyle(fontFamily: 'NexaBold'),
                                        )),
                                    child: child!);
                              },
                            );

                            if (month != null) {
                              setState(() {
                                _month = DateFormat('MMMM').format(month);
                              });
                            }
                            if (month != null) {
                              setState(() {
                                _day = DateFormat('dd MMMM yyyy').format(month);
                              });
                            }
                          },
                          child: Text(
                            'Pick Date',
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'NexaBold',
                                fontSize: screenWidth / 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 1.45,
                    child: FutureBuilder(
                      future: getRowCheckin(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  List list = snapshot.data;
                                  return list[index]['doc_date'] == _day
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              top: 12,
                                              right: 6,
                                              left: 6,
                                              bottom: 12),
                                          height: screenHeight / 3,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                  offset: Offset(2, 2))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                      margin: const EdgeInsets
                                                          .only(),
                                                      decoration: BoxDecoration(
                                                          color: primary,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Center(
                                                        child: Text(
                                                            'Loc: ${list[index]['location_index']}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'NexaBold',
                                                                fontSize:
                                                                    screenWidth /
                                                                        20,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    )),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Check In",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'NexaBold',
                                                                  fontSize:
                                                                      screenWidth /
                                                                          20,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                                list[index]
                                                                    ['checkin'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'NexaBold',
                                                                    fontSize:
                                                                        screenWidth /
                                                                            20,
                                                                    color: Colors
                                                                        .white)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Check Out",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'NexaBold',
                                                                  fontSize:
                                                                      screenWidth /
                                                                          20,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                                list[index][
                                                                    'checkout'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'NexaBold',
                                                                    fontSize:
                                                                        screenWidth /
                                                                            20,
                                                                    color: Colors
                                                                        .white)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 100,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  "Location :${list[index]['location']}",
                                                  style: TextStyle(
                                                      fontFamily: 'NexaBold',
                                                      fontSize:
                                                          screenWidth / 20,
                                                      color: Colors.black54)),
                                            ],
                                          ))
                                      : const SizedBox();
                                })
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}

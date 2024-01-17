import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kop_checkin/api/api.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:kop_checkin/planner.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:connectivity/connectivity.dart';

class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  final List<Color> _colorCollection = <Color>[];
  String? _networkStatusMsg;
  final Connectivity _internetConnectivity = new Connectivity();
  final List<Appointment> _appointmentDetails = <Appointment>[];
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Color.fromRGBO(12, 45, 92, 1);
  late List<Meeting> dataSource;
  String _day = DateFormat('yyyy').format(DateTime.now());
  Future getAgendar() async {
    var res = await http.post(Uri.parse(API.getAgenda),
        body: {'user_code': Users.id, 'year': DateFormat('yyyy').format(DateTime.now())});
    try {
      return jsonDecode(res.body);
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    _initializeEventColor();
    _checkNetworkStatus();

    super.initState();
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
    print(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    // setState(() {
    //
    // });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _day = DateFormat('dd MMMM yyyy').format(selectedDate!);
      });
      print('Date: ' + _day);

      // if (dataSource.isEmpty) {
      //   return;
      // }

      // for (int i = 0; i < dataSource.length; i++) {
      //   Appointment appointment = dataSource[i] as Appointment;

      //   /// It return the occurrence appointment for the given pattern appointment at the selected date.
      //   final Appointment? occurrenceAppointment =
      //       dataSource.getOccurrenceAppointment(appointment, selectedDate!, '');
      //   if ((DateTime(appointment.startTime.year, appointment.startTime.month,
      //               appointment.startTime._day) ==
      //           DateTime(
      //               selectedDate.year, selectedDate.month, selectedDate._day)) ||
      //       occurrenceAppointment != null) {
      //     setState(() {
      //       _appointmentDetails.add(appointment);
      //     });
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDataFromWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SfCalendar(
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(snapshot.data),
                      initialSelectedDate: DateTime.now(),
                      onSelectionChanged: selectionChanged,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: getAgendar(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    List list = snapshot.data;
                                    if (list[index]['docdate'] == _day) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            height: 60,
                                            color: Colors.blue,
                                            child: ListTile(
                                              leading: Column(
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    list[index]
                                                        ['location_index'],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        height: 1.5),
                                                  ),
                                                ],
                                              ),
                                              title: Container(
                                                child: Text(
                                                  list[index]['customer'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  })
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 5, right: 5),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Planner()));
                      },
                      icon: const Icon(FontAwesomeIcons.pencil),
                      label: const Text('Planner'),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('$_networkStatusMsg'),
            );
          }
        },
      ),
    );
  }

  Future<List<Meeting>> getDataFromWeb() async {
    var data = await http.post(
        Uri.parse(
            "https://www.project1.ts2337.com/checkin_App/api_sql/user/getAgenda.php"),
        body: {'user_code': Users.id, 'year': DateFormat('yyyy').format(DateTime.now())});
    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    // final Random random = new Random();
    try {
      for (var data in jsonData) {
        Meeting meetingData = Meeting(
            eventName: data['customer'],
            from: _convertDateFromString(
              data['timestamp'],
            ),
            to: _convertDateFromString(data['timestamp']),
            // background: _colorCollection[random.nextInt(9)],
            all_day: true);
        appointmentData.add(meetingData);
        setState(() {
          dataSource = appointmentData;
        });
      }
    } catch (e) {}

    return appointmentData;
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  void _checkNetworkStatus() {
    _internetConnectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _networkStatusMsg = result.toString();
        if (_networkStatusMsg == "ConnectivityResult.mobile") {
          _networkStatusMsg =
              "You are connected to mobile network, loading calendar data ....";
        } else if (_networkStatusMsg == "ConnectivityResult.wifi") {
          _networkStatusMsg =
              "You are connected to wifi network, loading calendar data ....";
        } else {
          _networkStatusMsg =
              "Internet connection may not be available. Connect to another network";
        }
      });
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  // @override
  // Color getColor(int index) {
  //   // return appointments![index].background;
  // }

  @override
  bool isAll_day(int index) {
    return appointments![index].all_day;
  }
}

class Meeting {
  Meeting({this.eventName, this.from, this.to, this.all_day = true});

  String? eventName;
  DateTime? from;
  DateTime? to;
  bool? all_day;
}

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kop_checkin/api/api.dart';
import 'package:kop_checkin/homescreen.dart';
import 'package:kop_checkin/login.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:kop_checkin/services/location_service.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: [MonthYearPickerLocalizations.delegate],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _startLocationService();
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

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeUser') != '') {
        setState(() {
          Users.username = sharedPreferences.getString('employeeUser')!;
          Users.id = sharedPreferences.getString('employeeID')!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable
        ? const HomeScreeen()
        : const KeyboardVisibilityProvider(
            child: LoginScreen(),
          );
  }
}

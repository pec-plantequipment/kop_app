import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kop_checkin/homescreen.dart';
import 'package:kop_checkin/login.dart';
import 'package:kop_checkin/model/user.dart';
import 'package:kop_checkin/services/location_service.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

bool isRunningInMockEnvironment() {
  // Check if the app is running in debug mode
  if (kDebugMode) {
    // Additional checks can be added based on your specific needs
    // For example, you might check for certain package dependencies
    // that are commonly used in mock environments during testing.

    // Check for a package commonly used for mocking data in tests
    try {
      // Attempt to import a package typically used for mocking
      // If it's not present in your production code, this could
      // indicate a testing environment
      // Note: This is just a simple example; it may not cover all cases
      // Class.forName("package:mockito/mockito.dart");
      return true;
    } catch (_) {
      // The package is not present, indicating a potential production environment
      return false;
    }
  }

  // The app is not running in debug mode, likely in release mode
  return false;
}

void main() async {
  bool isMockEnvironment = isRunningInMockEnvironment();
  print('Is running in mock environment: $isMockEnvironment');
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
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeUser') != '') {
        setState(() {
          Users.username = sharedPreferences.getString('username')!;
          Users.name_surname_en =
              sharedPreferences.getString('name_surname_en')!;
          Users.name_surname_th =
              sharedPreferences.getString('name_surname_th')!;
          Users.pec_group = sharedPreferences.getString('pec_group')!;
          Users.department = sharedPreferences.getString('department')!;
          Users.position = sharedPreferences.getString('position')!;
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

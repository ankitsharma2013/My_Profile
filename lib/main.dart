import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_profile/screens/home.dart';
import 'package:my_profile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? rememberMe = preferences.getBool("rememberMe");
  String? userName = preferences.getString("username");
  //If username has not been set previously then fill shared_preferences with fixed data.
  if (userName == null) {
    await preferences.setString("username", "ankit.sharma@darkbears.com");
    await preferences.setString("name", "Ankit Sharma");
    await preferences.setString(
        "skills", "Android, Flutter, Unity Development");
    await preferences.setString("work", "4 years");
  }

  if (rememberMe != null) {
    if (rememberMe) {
      runApp(const MyAppHome());
    } else {
      runApp(const MyAppLogin());
    }
  } else {
    runApp(const MyAppLogin());
  }
}

class MyAppLogin extends StatelessWidget {
  const MyAppLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'my profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const Login(title: 'Login'),
    );
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'my profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

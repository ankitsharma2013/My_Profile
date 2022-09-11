import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_profile/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController =
      TextEditingController(text: "ankit.sharma@darkbears.com");
  TextEditingController passwordController =
      TextEditingController(text: "Ankit Sharma");
  bool rememberMe = false;
  bool emailValid = true;
  bool passwordValid = true;
  double elevationX = 1.0;
  double elevationY = 1.0;
  double spreadRadius = 0.0;

  loginPressed() async {
    var navigator = Navigator.of(context);
    var scaffoldMsg = ScaffoldMessenger.of(context);
    emailValid = EmailValidator.validate(usernameController.text);
    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid Username"),
      ));
    }
    if (passwordController.text.length < 6) {
      setState(() {
        emailValid = emailValid;
        passwordValid = false;
      });
      return;
    } else {
      setState(() {
        emailValid = emailValid;
        passwordValid = true;
      });
    }

    if (emailValid && passwordValid) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? email = preferences.getString("username");
      if (usernameController.text == email! &&
          passwordController.text == "Ankit Sharma") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setBool("rememberMe", rememberMe);
        await preferences.setString("username", usernameController.text);

        navigator.pushReplacement(MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "Home")));
      } else {
        scaffoldMsg.showSnackBar(const SnackBar(
          content: Text(
              "User does not exist in database.\nPlease use correct credentials."),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // Navigation bar
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Icon(Icons.landscape_outlined, size: 150),
              const SizedBox(
                height: 80.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(.5),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: spreadRadius, //extend the shadow
                        offset: Offset(
                          elevationX, // Move to right 10  horizontally
                          elevationY, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            errorText:
                                emailValid ? null : "Enter valid Username",
                            suffixIcon: const Icon(Icons.email_outlined),
                            border: const OutlineInputBorder(),
                            filled: true,
                            hintText: "eg - ankit.sharma@darkbears.com",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            errorText:
                                passwordValid ? null : "Al least 6 characters",
                            suffixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            filled: true,
                            hintText: "eg - Ankit Sharma",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: rememberMe,
                                onChanged: (val) {
                                  setState(() {
                                    rememberMe = val!;
                                  });
                                }),
                            const Text("Remember me"),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                            onPressed: loginPressed,
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("Login"),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_profile/screens/edit_profile.dart';
import 'package:my_profile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences preferences;
  Uint8List? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController workController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refresh();
    });
  }

  getImage() {
    String? imageString = preferences.getString("image");
    if(imageString != null) {
      Uint8List bytes = base64Decode(imageString);
      setState(() {
        image = bytes;
      });
    }
  }

  refresh() async {
    preferences = await SharedPreferences.getInstance();
    nameController.text = preferences.getString("name")!;
    emailController.text = preferences.getString("username")!;
    skillsController.text = preferences.getString("skills")!;
    workController.text = preferences.getString("work")!;
    getImage();
  }

  editPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => const EditProfile(title: "Edit Profile")))
        .then((value) => refresh());
  }

  logout() async {
    var navigator = Navigator.of(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("rememberMe", false);
    navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const Login(title: "Login")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: logout, icon: const Icon(Icons.power_settings_new))
        ],
        centerTitle: true,
        title: Text(widget.title),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // Navigation bar
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              PhysicalModel(
                color: Colors.blue,
                elevation: 40,
                shadowColor: Colors.blue,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: image != null ? MemoryImage(image!) : null,
                  child: image != null
                      ? null
                      : const Icon(
                          Icons.person,
                          size: 100,
                        ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: nameController,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: "Name",
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: editPage,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: emailController,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: "Email",
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: editPage,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: skillsController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: "Skills",
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: editPage,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: workController,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: "Work Experience",
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: editPage,
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: editPage,
        tooltip: 'Edit Profile',
        label: const Text("Edit Profile"),
      ),
    );
  }
}

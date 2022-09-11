import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late SharedPreferences preferences;
  Uint8List? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController workController = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode skillsNode = FocusNode();
  FocusNode workNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      preferences = await SharedPreferences.getInstance();
      nameController.text = preferences.getString("name")!;
      emailController.text = preferences.getString("username")!;
      skillsController.text = preferences.getString("skills")!;
      workController.text = preferences.getString("work")!;
      getImage();
    });
  }

  saveProfile() async {
    var navigator = Navigator.of(context);
    var scaffoldMsg = ScaffoldMessenger.of(context);

    nameNode.unfocus();
    emailNode.unfocus();
    skillsNode.unfocus();
    workNode.unfocus();

    if (nameController.text == "" ||
        emailController.text == "" ||
        skillsController.text == "" ||
        workController.text == "") {
      scaffoldMsg.showSnackBar(const SnackBar(
        content: Text("Fields cannot be empty."),
      ));
    } else {
      await preferences.setString("username", emailController.text);
      await preferences.setString("name", nameController.text);
      await preferences.setString("skills", skillsController.text);
      await preferences.setString("work", workController.text);
      if(image != null) {
        await saveImage(image!);
      }

      navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "Home")));
    }
  }

  showSavePopup() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: const Text('Do you want to discard the changes?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); //Close Dialog
                        Navigator.of(context).pop(); //Go to previous page
                      },
                      child: const Text("Yes")),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); //Close Dialog
                      },
                      child: const Text("No")),
                ],
              ));
        });
  }

  Future<bool> saveImage(List<int> imageBytes) async {
    String base64Image = base64Encode(imageBytes);
    return preferences.setString("image", base64Image);
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

  Future<XFile?> getImageFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    return image;
  }

  changeProfile() async {
    var scaffoldMsg = ScaffoldMessenger.of(context);
    final PermissionStatus status = await Permission.photos.request();
    if (status == PermissionStatus.granted) {
      XFile? img = await getImageFromGallery();
      if (img != null) {
        File imageFile = File(img.path);
        Uint8List? pickedImage = await imageFile.readAsBytes();
        setState(() {
          image = pickedImage;
        });
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      scaffoldMsg.showSnackBar(const SnackBar(
        content: Text(
            "Photos permission has been permanently denied.\nPlease open app settings and enable it."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showSavePopup();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
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
                InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: changeProfile,
                  child: PhysicalModel(
                    color: Colors.blue,
                    elevation: 40,
                    shadowColor: Colors.blue,
                    shape: BoxShape.circle,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 3.0, right: 3.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.edit),
                          ),
                        ),
                        CircleAvatar(
                          radius: 100,
                          backgroundImage:
                              image != null ? MemoryImage(image!) : null,
                          child: image != null
                              ? null
                              : const Icon(
                                  Icons.person,
                                  size: 100,
                                ),
                        ),
                      ],
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
                        focusNode: nameNode,
                        controller: nameController,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: "Name",
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
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
                        focusNode: emailNode,
                        controller: emailController,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
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
                        focusNode: skillsNode,
                        controller: skillsController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: "Skills",
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
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
                        focusNode: workNode,
                        controller: workController,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: "Work Experience",
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                    onPressed: saveProfile, child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Save profile"),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodpanda_sellers_app/widgets/error_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  LocationPermission? permission;
  Position? position;
  List<Placemark>? placeMarks;

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];
    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare},'
        ' ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: "Please select an image"
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                      data: Icons.person,
                      controller: nameController,
                      hintText: "Name",
                      isObscure: false),
                  CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      isObscure: false),
                  CustomTextField(
                      data: Icons.lock,
                      controller: passwordController,
                      hintText: "Password",
                      isObscure: true),
                  CustomTextField(
                      data: Icons.lock,
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      isObscure: true),
                  CustomTextField(
                      data: Icons.phone,
                      controller: passwordController,
                      hintText: "Phone",
                      isObscure: false),
                  CustomTextField(
                      data: Icons.my_location,
                      controller: locationController,
                      hintText: "Cafe/Restaurant Address",
                      isObscure: false,
                      enabled: false),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my current Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      icon: const Icon(Icons.location_on, color: Colors.white),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 30),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 20)),
              onPressed: () {
                formValidation();
              },
              child: const Text(
                "Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

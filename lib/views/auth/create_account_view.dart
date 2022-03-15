import 'dart:io';

import 'package:familicious_app/manager/auth_manager.dart';
import 'package:familicious_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';
import 'package:image_cropper/image_cropper.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final AuthManager _authManager = AuthManager();

  File? _imageFile;

  Future selectImage({ImageSource imageSource = ImageSource.camera}) async {
    XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: selectedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'My Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: _imageFile == null
                      ? Image.asset(
                          'assets/images/defaultpic.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          _imageFile!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                            height: 100,
                            child: Column(children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  selectImage(imageSource: ImageSource.camera);
                                },
                                icon: const Icon(UniconsLine.camera),
                                label: const Text('Take Photo'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  selectImage(imageSource: ImageSource.gallery);
                                },
                                icon: const Icon(UniconsLine.camera),
                                label: const Text('Select From Gallery'),
                              ),
                            ]));
                      });
                },
                icon: const Icon(UniconsLine.camera),
                label: const Text('Select a profile picture'),
              ),
              const SizedBox(
                height: 35,
              ),
              TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    label: Text('Full Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Full name is required!";
                    }
                  }),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(label: Text('Email')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email is required";
                    }

                    if (value.length < 8) {
                      return "Email is invalid";
                    }
                  }),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(label: Text('Password')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required!";
                    }

                    if (value.length < 8) {
                      return "Password should be 8 characters long";
                    }
                  }),
              const SizedBox(
                height: 25,
              ),
              _authManager.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          bool isCreated = await _authManager.createNewUser(
                              name: name,
                              email: email,
                              password: password,
                              imageFile: _imageFile!);

                          if (isCreated) {
                            //new user created succesfully
                            Fluttertoast.showToast(
                                msg: "Welcome!, $name",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                                (route) => false);
                          } else {
                            //error occurred
                            Fluttertoast.showToast(
                                msg: _authManager.message,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          //validation failed
                          Fluttertoast.showToast(
                              msg: _authManager.message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background),
                      child: Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

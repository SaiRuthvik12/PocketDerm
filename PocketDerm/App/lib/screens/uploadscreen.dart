import 'dart:io';
// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketdermtest/components/roundedbutton.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:pocketdermtest/screens/resultscreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UploadScreen extends StatefulWidget {
  static const String id = 'upload_screen';
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  dynamic imageFile;
  dynamic tobeUploadedFile;
  bool showSpinner = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(
      () {
        imageFile = pickedFile!;
        tobeUploadedFile = File(imageFile.path);
      },
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(
      () {
        imageFile = pickedFile!;
        tobeUploadedFile = File(imageFile.path);
      },
    );
  }

  Future uploadImageToFirebase() async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref('image1.jpeg');
    await storageReference.putFile(tobeUploadedFile);
    String downloadURL = await storageReference.getDownloadURL();
    print(downloadURL);
  }

  Future<String> retrieveDataFromFirebase() async {
    int iterable = 0;
    var reference = FirebaseDatabase.instance.ref();
    var result = await reference.once();
    String rawResult = result.snapshot.value.toString();
    String finalResult = '';
    for (int i = 0; i < rawResult.length; i++) {
      if (rawResult[i] == ':') {
        iterable = i + 1;
      }
    }
    for (int i = iterable; i < rawResult.length; i++) {
      if (rawResult[i] != '}') {
        finalResult = finalResult + rawResult[i];
      }
    }
    print(finalResult);
    return finalResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.image,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100.0),
                    bottomRight: Radius.circular(100.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.black45,
                    ),
                  ),
                  child: (imageFile == null)
                      ? const Center(
                          child: Text(
                            'Choose An Image',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Image.file(
                          tobeUploadedFile,
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  bottom: 40.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _openCamera(context);
                          },
                          child: const Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _openGallery(context);
                          },
                          child: const Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 64.0,
                  right: 64.0,
                  bottom: 64.0,
                ),
                child: RoundedButton(
                  onPressed: () async {
                    if (tobeUploadedFile != null) {
                      setState(() {
                        showSpinner = true;
                      });
                      await uploadImageToFirebase();
                      Fluttertoast.showToast(
                        msg: "Uploaded Image",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );

                      await Future.delayed(const Duration(seconds: 18), () {
                        print(" This line is execute after 18 seconds");
                      });

                      String result = await retrieveDataFromFirebase();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              text: result,
                            ),
                          ));
                      setState(() {
                        showSpinner = false;
                      });
                    } else {
                      print('null image');
                    }
                  },
                  displayText: 'Submit',
                  color: Colors.purple.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

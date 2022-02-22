import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pocketdermtest/components/roundedbutton.dart';
import 'package:pocketdermtest/constants.dart';
import 'package:pocketdermtest/screens/loginscreen.dart';
import 'package:pocketdermtest/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String name;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 5.0,
                        ),
                        child: ImageIcon(
                          AssetImage('images/doctor_icon.png'),
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 50.0,
                        ),
                      ),
                    ],
                  ),
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
            const SizedBox(
              height: 80.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 40.0,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                  hintText: 'Name',
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 40.0,
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 40.0,
              ),
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 80.0,
                ),
                child: RoundedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        showSpinner = true;
                      });

                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            HomeScreen.id, (Route<dynamic> route) => false);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  // onPressed: () {
                  //   Navigator.popAndPushNamed(context, HomeScreen.id);
                  // },
                  displayText: 'Submit',
                  color: Colors.lightBlue.shade900,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 20.0,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Already have an account? Log In',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:triptale/src/presentation/home/home_page.dart';
import 'package:triptale/src/presentation/user_auth/edit_profile.dart';
import 'package:triptale/src/presentation/user_auth/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      bottomSheet: _isBottomSheet
          ? Container(
              padding: const EdgeInsets.all(20),
              width: double.maxFinite,
              height: 360,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Verify OTP",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text("Enter the OTP send you on your email id"),
                  Pinput(
                    length: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Don't receive OTP?"),
                      Text("Resend OTP"),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isBottomSheet = false;
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => EditProfile(),
                          //     ));
                        });
                      },
                      child: Text("Verify OTP"))
                ],
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          Expanded(child: SizedBox()),
          Container(
              height: 150,
              width: 150,
              child: Image.asset("assets/triptale_logo.png")),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            // height: 475,
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Here? Let’s Explore Together!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Text("Create your travel story today!"),
                  Text("Sign up & start exploring!"),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "email is required";
                      }
                      return null;
                    },
                    controller: emailController,
                    enabled: !_isBottomSheet,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Password",
                    ),
                  ),
                  // Text(
                  //   " You will recieve an 4 digit OTP",
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                  SizedBox(height: 10),
                  Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Enter Email and password"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              if (passwordController.text.length > 6) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Password should be greater than 6"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                              // await createUserWithEmailPassword();
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(),
                          ))),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Already have an account?  "),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signin(),
                            ));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ]),
                  // Container(
                  //     width: double.maxFinite,
                  //     child: ElevatedButton(
                  //         onPressed: () {
                  //           _isBottomSheet = true;
                  //           setState(() {});
                  //         },
                  //         child: Text(
                  //           "GET OTP",
                  //           style: TextStyle(),
                  //         ))),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

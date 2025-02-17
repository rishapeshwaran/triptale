import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        });
                      },
                      child: Text("Verify OTP"))
                ],
              ),
            )
          : null,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            // height: 475,
            width: double.maxFinite,
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
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Email",
                  ),
                ),
                Text(
                  " You will recieve an 4 digit OTP",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: () {
                          _isBottomSheet = true;
                          setState(() {});
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (context) {
                          //     return _OTPVerification();
                          //   },
                          // );
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return SizedBox(
                          //       height: 100,
                          //       width: 100,
                          //       child: Dialog(
                          //         child: _OTPVerification(),
                          //       ),
                          //     );
                          //   },
                          // );
                        },
                        child: Text(
                          "GET OTP",
                          style: TextStyle(),
                        ))),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

Container _OTPVerification() {
  return Container(
    width: double.maxFinite,
    height: 360,
    color: Colors.red,
    child: Column(
      children: [
        Text("Verify OTP"),
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
        ElevatedButton(onPressed: () {}, child: Text("Verify OTP"))
      ],
    ),
  );
}

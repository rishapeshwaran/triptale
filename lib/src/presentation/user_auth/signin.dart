import 'package:flutter/material.dart';
import 'package:triptale/src/presentation/user_auth/sign_up.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      backgroundColor: Colors.amber,
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
            height: 475,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back Traveler",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Sign in & start exploring!"),
                SizedBox(height: 10),
                TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Password",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Sign In",
                          style: TextStyle(),
                        ))),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?  "),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      )),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hcrl_quizapp/screens/homescreen.dart';
import 'package:hcrl_quizapp/screens/registerscreen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  //Variables
  static const lbColor = Color.fromRGBO(144, 224, 239, 1);
  static const mbColor = Color.fromRGBO(0, 180, 216, 1);
  static const dbColor = Color.fromRGBO(3, 4, 94, 1);
  static const List<Object> txtstyle = [
    TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: lbColor),
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mbColor),
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lbColor)
  ];

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  
  
  //Signin
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  var _statNow = 'GS';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'Prompt'),
              home: Scaffold(
                  backgroundColor: StartScreen.dbColor,
                  body: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/quiz-logo.png',
                        width: 200,
                        height: 200,
                        color: StartScreen.mbColor,
                      ),
                      const SizedBox(height: 30),
                      Text("Welcome to Quiz App!",
                          style: StartScreen.txtstyle[1] as TextStyle),
                      const SizedBox(height: 30),
                      _statNow == 'GS'
                          ? AnimatedOpacity(
                              opacity: _statNow == 'GS' ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _statNow = 'LG';
                                    });
                                  },
                                  icon:
                                      const Icon(Icons.arrow_right_alt_rounded),
                                  label: const Text(
                                    'Get Started',
                                  )))
                          : Text("Login",
                              style: StartScreen.txtstyle[2] as TextStyle),
                      AnimatedOpacity(
                          opacity: _statNow == 'LG' ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            width: 320,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    const Color.fromRGBO(202, 240, 248, 0.25)),
                            child: Column(
                              children: [
                                TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your password',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 30),
                                OutlinedButton.icon(
                                    onPressed: signIn,
                                    icon: const Icon(Icons.login),
                                    label: const Text(
                                      'Login',
                                    )),
                                const SizedBox(height: 15),
                                const Text("Signup is Under Development)",
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ))
                    ],
                  ))),
            );
          } else {
            return const HomeScreen();
          }
        });
  }
}

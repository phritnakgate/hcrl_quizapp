import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hcrl_quizapp/screens/welcomescreen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if(kIsWeb){
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "",
  //       appId: "",
  //       messagingSenderId: "",
  //       projectId: "",
  //     ),
  //   );
  // }else{
  await Firebase.initializeApp();
  
  runApp(const StartScreen());
}


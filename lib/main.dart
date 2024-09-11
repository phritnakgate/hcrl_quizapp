import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hcrl_quizapp/screens/welcomescreen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use compile-time constants for environment variables, injected via --dart-define
  const String appId = String.fromEnvironment('APPID', defaultValue: '');
  const String apiKey = String.fromEnvironment('APIKEY', defaultValue: '');
  const String messagingSenderId = String.fromEnvironment('MESSAGESERVICEID', defaultValue: '');
  const String projectId = String.fromEnvironment('PROJECTID', defaultValue: '');
  const String databaseUrl = String.fromEnvironment('DATABASEURL', defaultValue: '');

  // Initialize Firebase with environment variables
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: appId,
      apiKey: apiKey,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      databaseURL: databaseUrl,
    ),
  );
  
  runApp(const StartScreen());
}


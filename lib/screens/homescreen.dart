import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  //final User user;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Quiz App'),
                leading: const Icon(Icons.menu),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: const Icon(
                          Icons.logout_outlined,
                          size: 26.0,
                        ),
                      ))
                ]),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign in as ${FirebaseAuth.instance.currentUser}"),
                ],
              ),
            )));
  }
}

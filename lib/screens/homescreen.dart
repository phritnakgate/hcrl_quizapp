import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcrl_quizapp/screens/quizscreen.dart';

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
                    onTap: () {},
                    child: const Icon(
                      Icons.add,
                      size: 26.0,
                    ),
                  ),
                ),
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
                    )),
              ]),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['quiz_name']),
                      subtitle: Text(
                          "ID: ${snapshot.data!.docs[index].reference.id} Desc: ${snapshot.data!.docs[index]['quiz_desc']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                      quizId: snapshot
                                          .data!.docs[index].reference.id)));
                        },
                      ),
                    );
                  },
                );
              })),
    );
  }
}

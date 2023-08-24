import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcrl_quizapp/screens/quizscreen.dart';

class HomeScreen extends StatefulWidget {
  //final User user;

  const HomeScreen({super.key});

  //Color
  static const lbColor = Color.fromRGBO(144, 224, 239, 1);
  static const mbColor = Color.fromRGBO(0, 180, 216, 1);
  static const dbColor = Color.fromRGBO(3, 4, 94, 1);
  static const List<Object> txtstyle = [
    TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
        fontFamily: 'Prompt'),
    TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: dbColor,
        fontFamily: 'Prompt'),
    TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: lbColor,
        fontFamily: 'Prompt')
  ];

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
              title: const Text('Quiz App',
                  style: TextStyle(
                      fontFamily: 'Prompt', fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.menu),
              backgroundColor: const Color.fromRGBO(3, 4, 94, 1),
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
                      title: Text(snapshot.data!.docs[index]['quiz_name'],
                          style: HomeScreen.txtstyle[1] as TextStyle),
                      subtitle: Text(
                        "${snapshot.data!.docs[index].reference.id} : ${snapshot.data!.docs[index]['quiz_desc']}",
                        style: HomeScreen.txtstyle[0] as TextStyle,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                        quizId: snapshot
                                            .data!.docs[index].reference.id,
                                      )));
                        },
                      ),
                    );
                  },
                );
              })),
    );
  }
}

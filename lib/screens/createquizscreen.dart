import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcrl_quizapp/screens/homescreen.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  static final currentUser = FirebaseAuth.instance.currentUser!;

  //Style
  static const lbColor = Color.fromRGBO(144, 224, 239, 1);
  static const mbColor = Color.fromRGBO(0, 180, 216, 1);
  static const dbColor = Color.fromRGBO(3, 4, 94, 1);
  static const List<Object> txtstyle = [
    TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: dbColor),
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: dbColor),
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lbColor)
  ];

  //Form Controller
  static final qname = TextEditingController();
  static final qdesc = TextEditingController();
  static final noQ = TextEditingController();
  static bool publicVisibility = false;

  //Connect Firebase
  static final db = FirebaseFirestore.instance.collection('quiz');

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Create Quiz',
                style: TextStyle(
                    fontFamily: 'Prompt', fontWeight: FontWeight.bold)),
            backgroundColor: CreateQuizScreen.dbColor,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 26.0,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: CreateQuizScreen.qname,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quiz Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: CreateQuizScreen.qdesc,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quiz Description',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.white,
                        value: CreateQuizScreen.publicVisibility,
                        onChanged: (bool? value) {
                          setState(() {
                            CreateQuizScreen.publicVisibility = value!;
                          });
                        }),
                    const Text('Check if want to make this quiz public.',
                        style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 16,
                            color: CreateQuizScreen.dbColor)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: CreateQuizScreen.noQ,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number of Questions',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var newQuiz = {
                      'quiz_name': CreateQuizScreen.qname.text,
                      'quiz_desc': CreateQuizScreen.qdesc.text,
                      'quiz_owner': CreateQuizScreen.currentUser.email,
                      'quiz_visibility': CreateQuizScreen.publicVisibility,
                      'quiz_questions': []
                    };
                    if (CreateQuizScreen.qname.text.isEmpty ||
                        CreateQuizScreen.qdesc.text.isEmpty ||
                        CreateQuizScreen.noQ.text.isEmpty) {
                      print("Please fill out all fields.");
                    } else {
                      CreateQuizScreen.db.add(newQuiz);
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()))
                          .then((value) => {
                                CreateQuizScreen.qname.clear(),
                                CreateQuizScreen.qdesc.clear(),
                                CreateQuizScreen.noQ.clear(),
                                CreateQuizScreen.publicVisibility = false
                              });
                    }
                  },
                  child: const Text('Create Quiz'),
                ),
              ],
            ),
          )),
    );
  }
}

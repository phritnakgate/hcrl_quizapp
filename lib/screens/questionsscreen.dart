import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QData {
  String question = "";
  List<String> choices = ["", "", "", ""];
  String correct_answer = "";
  String solution = "";
  int points = 0;
}

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen({required this.question, required this.noQ, super.key});

  final Map<String, dynamic> question;
  final int noQ;
  static const lbColor = Color.fromRGBO(144, 224, 239, 1);
  static const mbColor = Color.fromRGBO(0, 180, 216, 1);
  static const dbColor = Color.fromRGBO(3, 4, 94, 1);
  static const List<Object> txtstyle = [
    TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: dbColor),
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: dbColor),
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lbColor)
  ];

  //Connect Firebase
  static final db = FirebaseFirestore.instance.collection('quiz');

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQ = 1;

  final QData qdata = QData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
              child: Column(
            children: [
              Text('Question $currentQ/${widget.noQ}',
                  style: QuestionsScreen.txtstyle[1] as TextStyle),
              TextField(
                onChanged: (text) {
                  setState(() {
                    qdata.question = text;
                  });
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Question $currentQ'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (text) {
                  setState(() {
                    qdata.solution = text;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Solution'),
              ),
              Text('Choices', style: QuestionsScreen.txtstyle[0] as TextStyle),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) => SizedBox(
                  width: 200,
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        qdata.choices[index] = text;
                      });
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Choice ${index + 1}'),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Correct Answer: ',
                    style: QuestionsScreen.txtstyle[0] as TextStyle),
                DropdownButton(
                  onChanged: (dynamic value) {
                    setState(() {
                      qdata.correct_answer = qdata.choices[value];
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      child: Text("Choice 1"),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Choice 2'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Choice 3'),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text('Choice 4'),
                      value: 3,
                    ),
                  ],
                ),
                Text('Points: ',
                    style: QuestionsScreen.txtstyle[0] as TextStyle),
                SizedBox(
                  width: 75,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number of Questions',
                    ),
                    onChanged: (text) {
                      setState(() {
                        qdata.points = int.parse(text);
                      });
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (currentQ < widget.noQ) {
                    setState(() {
                      Map<String, dynamic> gen_q = {
                        "question": qdata.question,
                        "solution": qdata.solution,
                        "choices": qdata.choices,
                        "correct_answer": qdata.correct_answer,
                        "points": qdata.points
                      };
                      widget.question['quiz_questions'].add(gen_q);
                      print(widget.question['quiz_questions']);
                      currentQ++;
                    });
                  } else {
                    setState(() {
                      Map<String, dynamic> gen_q = {
                        "question": qdata.question,
                        "solution": qdata.solution,
                        "choices": qdata.choices,
                        "correct_answer": qdata.correct_answer,
                        "points": qdata.points
                      };
                      widget.question['quiz_questions'].add(gen_q);
                      print(widget.question['quiz_questions']);
                      QuestionsScreen.db.add(widget.question);
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          )),
        ));
  }
}

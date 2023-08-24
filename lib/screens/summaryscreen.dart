import 'package:flutter/material.dart';
import 'package:hcrl_quizapp/screens/homescreen.dart';
import 'package:hcrl_quizapp/screens/quizscreen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen(
      {required this.qid,
      required this.qdata,
      required this.correct,
      required this.totalScore,
      required this.score,
      required this.isCorrect,
      super.key});

  final String qid;
  final Map<String, dynamic> qdata;
  final int correct;
  final num totalScore;
  final num score;
  final List<bool> isCorrect;

  //Hint
  static Map<num, String> hint = {};
  void isIncorrect() {
    for (var i = 0; i < qdata['quiz_questions'].length; i++) {
      if (isCorrect[i] == false) {
        hint[i + 1] = qdata['quiz_questions'][i]['solution'];
      }
    }
  }

  //Color
  static const lbColor = Color.fromRGBO(144, 224, 239, 1);
  static const mbColor = Color.fromRGBO(0, 180, 216, 1);
  static const dbColor = Color.fromRGBO(3, 4, 94, 1);
  static const List<Object> txtstyle = [
    TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: lbColor,
        fontFamily: 'Prompt'),
    TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: mbColor,
        fontFamily: 'Prompt'),
    TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: lbColor,
        fontFamily: 'Prompt'),
    TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: lbColor,
        fontFamily: 'Prompt'),
  ];

  @override
  Widget build(BuildContext context) {
    isIncorrect();
    return Scaffold(
      backgroundColor: dbColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'You got: $score / $totalScore',
            style: SummaryScreen.txtstyle[1] as TextStyle,
          ),
          const SizedBox(height: 20),
          score == totalScore
              ? Text(
                  'Perfect! You got all correct!',
                  style: SummaryScreen.txtstyle[2] as TextStyle,
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: hint.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Q${hint.keys.elementAt(index)}',
                        style: SummaryScreen.txtstyle[1] as TextStyle,
                      ),
                      subtitle: Text(hint.values.elementAt(index),
                          style: SummaryScreen.txtstyle[3] as TextStyle),
                    );
                  }),
          const SizedBox(height: 20),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  hint = {};
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
                label: const Text(
                  'Back to Home',
                  style: TextStyle(
                      fontFamily: "Prompt", color: lbColor, fontSize: 18),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.restart_alt),
                onPressed: () {
                  hint = {};
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => QuizScreen(
                            quizId: qid,
                          )));
                },
                label: const Text(
                  'Restart',
                  style: TextStyle(
                      fontFamily: "Prompt", color: lbColor, fontSize: 20),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}

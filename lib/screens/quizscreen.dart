import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcrl_quizapp/screens/summaryscreen.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/answer_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quizId});

  final String quizId;

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
        fontFamily: 'Prompt')
  ];

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  //Summary
  int _correct = 0;
  List<bool> _isCorrect = [];
  int _totalQuestion = 0;
  int _currentQuestion = 1;
  num _score = 0;
  num _totalScore = 0;

  void answerQuestion(Map<String, dynamic> m, List q, String selectedAnswer) {
    setState(() {
      if (q[_currentQuestion - 1]['correct_answer'] == selectedAnswer) {
        _totalScore += q[_currentQuestion - 1]['points'];
        _correct++;
        _isCorrect.add(true);
        _score += q[_currentQuestion - 1]['points'];
        if (_currentQuestion == _totalQuestion) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SummaryScreen(
                qid: widget.quizId,
                qdata: m,
                correct: _correct,
                totalScore: _totalScore,
                score: _score,
                isCorrect: _isCorrect,)));
          return;
        }
      } else {
        _totalScore += q[_currentQuestion - 1]['points'];
        _isCorrect.add(false);
        if (_currentQuestion == _totalQuestion) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SummaryScreen(
                qid: widget.quizId,
                qdata: m,
                correct: _correct,
                totalScore: _totalScore,
                score: _score,
                isCorrect: _isCorrect,
              )));
          return;
        }
      }
      _currentQuestion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quiz')
            .doc(widget.quizId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          var quizData = snapshot.data!.data() as Map<String, dynamic>;
          var questions = quizData['quiz_questions'] as List<dynamic>;
          _totalQuestion = questions.length;
          

          return Scaffold(
            backgroundColor: QuizScreen.dbColor,
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quizData['quiz_name'],
                      style: QuizScreen.txtstyle[1] as TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 45),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 10.0,
                      percent: _currentQuestion / _totalQuestion,
                      progressColor: Colors.cyanAccent,
                    ),
                    const SizedBox(height: 30),
                    Text("Question $_currentQuestion/$_totalQuestion",
                        style: QuizScreen.txtstyle[1] as TextStyle),
                    const SizedBox(height: 30),
                    Text(
                      questions[_currentQuestion - 1]['question'],
                      style: QuizScreen.txtstyle[0] as TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ...questions[_currentQuestion - 1]['choices'].map((answer) {
                      return AnswerButton(
                        answerText: answer,
                        onTap: () {
                          answerQuestion(quizData, questions, answer);
                        },
                      );
                    }),
                  ]),
            ),
          );
        });
  }
}

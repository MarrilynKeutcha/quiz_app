import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import 'summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int category;
  final String difficulty;
  final String questionType;

  const QuizScreen({
    Key? key,
    required this.numberOfQuestions,
    required this.category,
    required this.difficulty,
    required this.questionType,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    final response = await ApiService.fetchQuestions(
      amount: widget.numberOfQuestions,
      category: widget.category,
      difficulty: widget.difficulty,
      type: widget.questionType,
    );
    setState(() {
      questions = response.map((q) => Question.fromJson(q)).toList();
      isLoading = false;
    });
  }

  void nextQuestion(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) {
      score++;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            score: score,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Column(
        children: [
          Text("Question ${currentQuestionIndex + 1} of ${questions.length}"),
          Text(question.question),
          ...question.options.map(
            (option) => ElevatedButton(
              onPressed: () => nextQuestion(option),
              child: Text(option),
            ),
          ),
        ],
      ),
    );
  }
}

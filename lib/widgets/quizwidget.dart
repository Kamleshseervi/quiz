import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class QuizWidget extends StatefulWidget {
  final DocumentSnapshot quiz;

  const QuizWidget({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentPageIndex = 0;
  late PageController _pageController;
  late List<DocumentSnapshot> _questions;
  late List<String?> _userAnswers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestions();
  }

  void _loadQuestions() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quiz.id)
        .collection('questions')
        .get()
        .then((querySnapshot) {
      setState(() {
        _questions = querySnapshot.docs;
        _userAnswers = List.filled(_questions.length, null);
      });
    }).catchError((error) {
      print('Error getting questions: $error');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: _questions == null || _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionPage(index);
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _currentPageIndex > 0 ? _previousQuestion : null,
                      child: Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: _currentPageIndex < _questions.length - 1
                          ? _nextQuestion
                          : _submitQuiz,
                      child: Text(
                        _currentPageIndex < _questions.length - 1
                            ? 'Next'
                            : 'Submit Quiz',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildQuestionPage(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Question ${index + 1} of ${_questions.length}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _questions[index]['questionText'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildOptions(index),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  List<Widget> _buildOptions(int index) {
    List<Widget> options = [];

    if (_questions.isNotEmpty && _questions[index]['options'] is List) {
      List<dynamic> currentOptions = _questions[index]['options'];

      for (dynamic option in currentOptions) {
        options.add(RadioListTile<String>(
          title: Text(option.toString()),
          value: option.toString(),
          groupValue: _userAnswers[index],
          onChanged: (value) {
            setState(() {
              _userAnswers[index] = value;
            });
          },
        ));
      }
    } else {
      options.add(Text('Options not available'));
    }

    return options;
  }

  void _previousQuestion() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _nextQuestion() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _submitQuiz() {
    int marks = _calculateMarks();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScorePage(
          marks: marks,
          totalQuestions: _questions.length,
          questions: _questions,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  int _calculateMarks() {
    int marks = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i]['correctAnswer']) {
        marks++;
      }
    }
    return marks;
  }
}

class ScorePage extends StatelessWidget {
  final int marks;
  final int totalQuestions;
  final List<DocumentSnapshot> questions;
  final List<String?> userAnswers;

  const ScorePage({
    Key? key,
    required this.marks,
    required this.totalQuestions,
    required this.questions,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $marks out of $totalQuestions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: totalQuestions,
                itemBuilder: (context, index) {
                  return _buildQuestionAnalysis(index);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnalysis(int index) {
    final isCorrect = userAnswers[index] == questions[index]['correctAnswer'];
    final List<dynamic> options = questions[index]['options'];
    final correctOptionIndex = options
        .indexWhere((option) => option == questions[index]['correctAnswer']);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${index + 1}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Your Answer: ${userAnswers[index]}',
            style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            'Correct Answer: ${questions[index]['correctAnswer']}',
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(height: 8),
          Text(
            'Correct Option: ${options[correctOptionIndex]}',
            style: TextStyle(color: Colors.green),
          ),
          Divider(), // Add a divider for better separation
        ],
      ),
    );
  }
}

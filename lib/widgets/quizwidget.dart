import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled/utils/colors.dart';

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
        backgroundColor: AppColors.mainColor,
        title: Text("ExaQ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                    SizedBox(
                      width: 140,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          primary: AppColors.mainColor,
                            shadowColor: Colors.blueGrey,
                            elevation: 5,
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),

                        ),
                        onPressed:
                            _currentPageIndex > 0 ? _previousQuestion : null,
                        child: Text('Previous', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: AppColors.mainColor,
                          shadowColor: Colors.blueGrey,
                          elevation: 5,
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),
                        ),
                        onPressed: _currentPageIndex < _questions.length - 1
                            ? _nextQuestion
                            : _submitQuiz,
                        child: Text(
                          _currentPageIndex < _questions.length - 1
                              ? 'Next'
                              : 'Submit Quiz',style: TextStyle(color: Colors.white),
                        ),
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
        
        Container(
          height: MediaQuery.of(context).size.height*2/7,
          width: MediaQuery.of(context).size.width,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 8,
                margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.lightGreenAccent,
                ),
              ),


              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(

                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Question ${index + 1} of ${_questions.length}',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20,5,20,5),
                height: 1,
                color: Colors.blueGrey.shade300,
              ),


              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10,20, 30),
                  child: Text(
                    _questions[index]['questionText'],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),

            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 3), // Offset in the x, y direction
              ),
            ],
          ),
        ),


        SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  _buildOptions(index),
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
        options.add(
            Center(
              child: Container(

                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width*6/7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 3), // Offset in the x, y direction
                    ),
                  ],
                ),
              child: RadioListTile<String>(
                

                        title: Text(option.toString(), style: TextStyle(fontSize: 14,),),
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                        value: option.toString(),
                        dense: true,
                        groupValue: _userAnswers[index],
                        onChanged: (value) {
              setState(() {
                _userAnswers[index] = value;
              });
              controlAffinity: ListTileControlAffinity.leading;
                        },
                      )),
            ),);
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
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },

                child: Text('Analyze', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10), // Set the border radius here
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },

                child: Text('Continue', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.mainColor,
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10), // Set the border radius here
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

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
            '   Question ${index + 1}:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isCorrect ? AppColors.lightGreen : AppColors.lightRed,
            ),
            child: Center(
              child: Container(
                width: double.infinity * 6/7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(questions[index]['questionText'], style: TextStyle(color: Colors.black),),
                    SizedBox(height: 10,),


                    SizedBox(height: 8),
                    Text(
                      'Correct Answer: ${questions[index]['correctAnswer']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

            ),
          ),
          SizedBox(height: 8),
          Text(
            '     Your Answer: ${userAnswers[index]}',
            style: TextStyle(color: isCorrect ? Colors.green : Colors.red.shade200),
          ),

          Divider(), // Add a divider for better separation
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/quizmodel.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> fetchQuizzes() async {
    List<Quiz> quizzes = [];

    try {
      QuerySnapshot<Map<String, dynamic>> quizSnapshot =
          await _firestore.collection('quizzes').get();

      for (var doc in quizSnapshot.docs) {
        List<Question> questions = [];
        var questionSnapshot =
            await doc.reference.collection('questions').get();

        questionSnapshot.docs.forEach((questionDoc) {
          List<String> options = List<String>.from(questionDoc['options']);
          Question question = Question(
            questionText: questionDoc['questionText'],
            options: options,
            correctAnswer: questionDoc['correctAnswer'],
          );
          questions.add(question);
        });

        Quiz quiz = Quiz(
          title: doc['title'],
          questions: questions,
        );

        quizzes.add(quiz);
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
    }

    return quizzes;
  }
}

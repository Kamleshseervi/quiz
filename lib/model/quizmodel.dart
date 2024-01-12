class Quiz {
  late String title;
  late List<Question> questions;

  Quiz({required this.title, required this.questions});
}

class Question {
  late String questionText;
  late List<String> options;
  late String correctAnswer;

  Question(
      {required this.questionText,
      required this.options,
      required this.correctAnswer});
}

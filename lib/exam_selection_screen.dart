import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class ExamCategoryScreen extends StatefulWidget {
  @override
  _ExamCategoryScreenState createState() => _ExamCategoryScreenState();
}

class _ExamCategoryScreenState extends State<ExamCategoryScreen> {
  String selectedExamCategory = '';
  String selectedState = '';

  void setSelectedExamCategory(String category) {
    setState(() {
      selectedExamCategory = category;
    });
  }

  void setSelectedState(String state) {
    setState(() {
      selectedState = state;
    });
  }

  void navigateToScreenBasedOnCategory() {
    if (selectedExamCategory == 'State Govt Jobs') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StateListScreen(
            onStateSelected: (selectedState) {
              // Handle selected state
              // You can save it or perform any other action
              setSelectedState(selectedState);
            },
          ),
        ),
      );
    } else {
      // Navigate to home screen or any other screen for other exam categories
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExamCategoryButton('UPSC', () {
              setSelectedExamCategory('UPSC');
              navigateToScreenBasedOnCategory();
            }),
            SizedBox(height: 10), // Add a gap between categories
            ExamCategoryButton('Banking Jobs', () {
              setSelectedExamCategory('Banking Jobs');
              navigateToScreenBasedOnCategory();
            }),
            SizedBox(height: 10), // Add a gap between categories
            ExamCategoryButton('SSC', () {
              setSelectedExamCategory('SSC');
              navigateToScreenBasedOnCategory();
            }),
            SizedBox(height: 10), // Add a gap between categories
            ExamCategoryButton('State Govt Jobs', () {
              setSelectedExamCategory('State Govt Jobs');
              navigateToScreenBasedOnCategory();
            }),
            SizedBox(height: 20),
            Text('Selected Exam Category: $selectedExamCategory'),
            SizedBox(
              height: 10,
            ), // Add a gap between the selected category and state
            Text('Selected State: $selectedState'),
          ],
        ),
      ),
    );
  }
}

class ExamCategoryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ExamCategoryButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10), // Add a gap above the button
        ListTile(
          title: Text(text),
          tileColor: Colors.blue,
          onTap: onPressed,
        ),
        SizedBox(height: 10), // Add a gap below the button
      ],
    );
  }
}

class StateListScreen extends StatelessWidget {
  final List<String> states = [
    'Rajasthan',
    'Uttar Pradesh',
    'Delhi',
    'Haryana',
    'Telangana',
    'Tamil Nadu',
    // Add more states as needed
  ];

  final Function(String) onStateSelected;

  StateListScreen({required this.onStateSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select State'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: states.map((state) {
              return Column(
                children: [
                  SizedBox(height: 10), // Add a gap above the button
                  ListTile(
                    title: Text(state),
                    tileColor: Colors.blue,
                    onTap: () {
                      // Pass the selected state to the ExamListScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamListScreen(
                            selectedState: state,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10), // Add a gap below the button
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ExamListScreen extends StatelessWidget {
  final String selectedState;

  ExamListScreen({required this.selectedState});

  @override
  Widget build(BuildContext context) {
    // You can customize this screen to display exams based on the selected state
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams in $selectedState'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExamButton('RAS', () {
              // Handle RAS exam
              // Navigate to HomeScreen or perform any other action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }),
            SizedBox(height: 10), // Add a gap between exams
            ExamButton('Patwari', () {
              // Handle Patwari exam
              // Navigate to HomeScreen or perform any other action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }),
            SizedBox(height: 10), // Add a gap between exams
            ExamButton('REET', () {
              // Handle REET exam
              // Navigate to HomeScreen or perform any other action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }),
            SizedBox(height: 10), // Add a gap between exams
            ExamButton('Forest Guard', () {
              // Handle Forest Guard exam
              // Navigate to HomeScreen or perform any other action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ExamButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ExamButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10), // Add a gap above the button
        ListTile(
          title: Text(text),
          tileColor: Colors.blue,
          onTap: onPressed,
        ),
        SizedBox(height: 10), // Add a gap below the button
      ],
    );
  }
}

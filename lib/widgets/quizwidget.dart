import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double progress;

  CustomWidget(
      {required this.name, required this.imageUrl, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image from URL
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Colored Strip with Name in Center
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue, // Change this color as needed
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Progress Bar at Top Right
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                value: progress,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Example Usage:
// CustomWidget(
//   name: 'John Doe',
//   imageUrl: 'https://example.com/image.jpg', // Replace this with your image URL
//   progress: 0.7, // Replace with your progress value (0.0 to 1.0)
// )

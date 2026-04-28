
import 'package:flutter/material.dart';
import 'package:finalexam_salaries/view/homepage.dart';
import 'package:finalexam_salaries/view/searchpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/home',
          routes: {
            '/home': (context) => MyHomePage(title: 'FinalExamSalaries'),
            '/search': (context) => const SearchPage(),
          }
    );
    
  }
}



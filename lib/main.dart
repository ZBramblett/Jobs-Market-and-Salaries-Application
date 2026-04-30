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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 82, 45),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 82, 45),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(title: 'FinalExamSalaries'),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}

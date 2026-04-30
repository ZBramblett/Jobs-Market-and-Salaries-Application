import 'package:flutter/material.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            CustomButton(text: 'Example button', onPressed: _incrementCounter),
            CustomCard(
              title: 'Example card',
              description:
                  'Description for the example card\nUse this for search results and whatnot\nOr other listed items',
              onPressed: _incrementCounter,
            ),
            CustomSettingsItem(
              text: 'Toggle Example',
              style: 'toggle',
              onToggle: (val) {
                print("Toggled: $val");
              },
            ),
            CustomSettingsItem(
              text: 'Button Example',
              style: 'button',
              buttonText: 'Execute',
              onPressed: _incrementCounter,
            ),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

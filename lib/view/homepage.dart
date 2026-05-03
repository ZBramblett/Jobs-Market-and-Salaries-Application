import 'package:finalexam_salaries/view/graphics_page.dart';
import 'package:flutter/material.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import '../presenter/auth_presenter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const GraphicsPageScreen()));
            }, 
            tooltip: 'Analytics',
            icon: const Icon(Icons.analytics))
        ],
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

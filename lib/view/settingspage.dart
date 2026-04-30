import 'package:finalexam_salaries/main.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSettingsItem(
              text: 'Toggle dark mode',
              style: 'toggle',
              initialValue: Theme.of(context).brightness == Brightness.dark,
              onToggle: (value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            CustomSettingsItem(
              text: 'Log Out',
              style: 'button',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

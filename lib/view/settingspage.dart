import 'package:finalexam_salaries/main.dart';
import 'package:finalexam_salaries/presenter/auth_presenter.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final isGuestMode =
      (AuthPresenter.authPresenter.currentUser?.displayName?.isEmpty ?? true) &&
      (AuthPresenter.authPresenter.currentUser?.email?.isEmpty ?? true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              title: isGuestMode
                  ? "Guest mode"
                  : AuthPresenter.authPresenter.currentUser?.displayName ??
                        "No name",
              description: isGuestMode
                  ? "Guest mode"
                  : AuthPresenter.authPresenter.currentUser?.email ??
                        'isGuestMode=${isGuestMode}\ndisplayName=${AuthPresenter.authPresenter.currentUser?.displayName}\nemail=${AuthPresenter.authPresenter.currentUser?.email}\nisEmpty=${AuthPresenter.authPresenter.currentUser?.displayName?.isEmpty}\nisNull=${AuthPresenter.authPresenter.currentUser?.displayName == null}\nisNull=${AuthPresenter.authPresenter.currentUser?.email == null}',
              onPressed: () async {
                await AuthPresenter().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              buttonText: isGuestMode ? "Log out" : "Sign up",
            ),
            CustomSettingsItem(
              text: 'Toggle dark mode',
              style: 'toggle',
              initialValue: Theme.of(context).brightness == Brightness.dark,
              onToggle: (value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ],
        ),
      ),
    );
  }
}

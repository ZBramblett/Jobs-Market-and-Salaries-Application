import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalexam_salaries/main.dart';
import 'package:finalexam_salaries/presenter/auth_presenter.dart';
import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isGuestMode;
  String? _displayName;

  @override
  void initState() {
    super.initState();
    final user = AuthPresenter.authPresenter.currentUser;
    isGuestMode =
        (user?.displayName?.isEmpty ?? true) &&
        (user?.email?.isEmpty ?? true);
    _displayName = user?.displayName;
  }

  Future<void> _editDisplayName() async {
    final controller = TextEditingController(text: _displayName ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set display name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter your name'),
          onSubmitted: (val) => Navigator.pop(ctx, val.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      FirebaseAuth.instance.currentUser?.updateDisplayName(result);
      setState(() => _displayName = result);
    }
  }

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
                  : (_displayName?.isNotEmpty == true ? _displayName! : "No name"),
              description: isGuestMode
                  ? "Guest mode"
                  : AuthPresenter.authPresenter.currentUser?.email ?? '',
              onPressed: () async {
                await AuthPresenter().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              buttonText: isGuestMode ? "Sign up" : "Log out",
              onEdit: isGuestMode ? null : _editDisplayName,
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

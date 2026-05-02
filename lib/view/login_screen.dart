
import 'package:flutter/material.dart';
import '../presenter/auth_presenter.dart';
import '../presenter/theme_presenter.dart';
import '../view/UI_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _presenter = AuthPresenter();

  String? _errorMessage;

  void _handleLogin() async {
    final error = await _presenter.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      // await notificationPresenter.setupPushNotifications();
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleForgotPassword() async {
    final dialogEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        String? dialogError;
        bool sent = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reset Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your email and we\'ll send you a password reset link.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dialogEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(125),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          themePresenter.BORDER_RADIUS.toDouble(),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          themePresenter.BORDER_RADIUS.toDouble(),
                        ),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      dialogError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (sent) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Reset link sent! Check your inbox.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: sent
                      ? null
                      : () async {
                          final email = dialogEmailController.text.trim();
                          if (email.isEmpty) {
                            setDialogState(
                              () => dialogError = 'Please enter your email.',
                            );
                            return;
                          }
                          final error = await _presenter.sendPasswordResetEmail(
                            email,
                          );
                          setDialogState(() {
                            dialogError = error;
                            sent = error == null;
                          });
                        },
                  child: const Text('Send Link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleGuestSignIn() async {
    final error = await _presenter.signInAnonymously();
    if (error == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = error);
    }
  }

  void _handleGoogleSignIn() async {
    final result = await _presenter.signInWithGoogle();
    if (result == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = themePresenter.BORDER_RADIUS.toDouble();
    final scheme = Theme.of(context).colorScheme;

    InputDecoration fieldDecoration(String label, IconData icon) =>
        InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: scheme.onPrimary),
          filled: true,
          fillColor: scheme.primary.withAlpha(125),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
            borderSide: BorderSide(color: scheme.onPrimary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
            borderSide: BorderSide(color: scheme.onPrimary, width: 1),
          ),
          prefixIcon: Icon(icon),
          prefixIconColor: scheme.onPrimary,
        );

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Jobs Market &\nSalaries Application',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _emailController,
                decoration: fieldDecoration('Email', Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: fieldDecoration('Password', Icons.lock),
                obscureText: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: scheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),

              CustomButton(text: 'Login', width: 'span', onPressed: _handleLogin),
              const SizedBox(height: 24),

              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: TextStyle(color: scheme.onSurface.withAlpha(150))),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              CustomButton(
                text: 'Sign in with Google',
                style: 'secondary',
                width: 'span',
                onPressed: _handleGoogleSignIn,
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Continue as Guest',
                style: 'secondary',
                width: 'span',
                onPressed: _handleGuestSignIn,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
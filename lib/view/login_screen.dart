
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
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Title
                const Text(
                  'DreamzZZzz',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Email Field
                TextField(
                  controller: _emailController,
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
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 1,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        themePresenter.BORDER_RADIUS.toDouble(),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 1,
                      ),
                    ),

                    prefixIcon: Icon(Icons.lock),
                    prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 1,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        themePresenter.BORDER_RADIUS.toDouble(),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 1,
                      ),
                    ),

                    prefixIcon: Icon(Icons.lock),
                    prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Login Button
                CustomButton(
                  text: 'Login',
                  width: 'span',
                  onPressed: _handleLogin,
                ),
                CustomButton(
                  text: "Sign in with Google",
                  style: 'secondary',
                  width: 'span',
                  onPressed: _handleGoogleSignIn,
                ),
                const SizedBox(height: 16),
                // Sign Up Link
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(
                        themePresenter.BORDER_RADIUS.toDouble(),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                            ),
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        themePresenter.BORDER_RADIUS.toDouble(),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Forgot your password? "),
                        TextButton(
                          onPressed: () {
                            _handleForgotPassword();
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                            ),
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          child: const Text('Reset Password'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
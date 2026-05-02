import 'package:flutter/material.dart';
import '../presenter/auth_presenter.dart';
import '../presenter/theme_presenter.dart';
import '../view/UI_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _presenter = AuthPresenter();

  String? _errorMessage;

  void _handleSignUp() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    final error = await _presenter.signUp(
      _emailController.text.trim(),
      password,
    );
    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
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
                'Create Account',
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
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                decoration: fieldDecoration('Confirm Password', Icons.lock_outline),
                obscureText: true,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: scheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),

              CustomButton(text: 'Sign Up', width: 'span', onPressed: _handleSignUp),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Login'),
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
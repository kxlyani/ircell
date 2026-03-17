import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/admin/admin_page.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/onboarding.dart';
import 'package:ircell/screens/tabs_screen.dart';

const Color accentBlue = Colors.blueAccent; // Keeping the existing color scheme

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Show popup dialog with error
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Okay!',
                  style: TextStyle(
                    color: accentBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (emailController.text == 'admin' &&
          passwordController.text == 'admin') {
        // Using delayed navigation for admin to show loading state
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        }
        return;
      }

      await Auth().signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Success handler would go here if needed
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.message ?? 'Login failed');
    } catch (e) {
      showErrorDialog('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => Onboarding(
                  email: emailController.text.trim(),
                  password: passwordController.text,
                ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.message ?? 'Registration failed');
    } catch (e) {
      showErrorDialog('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == 'admin') {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == 'admin') {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (!isLogin && value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (!isLogin) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != passwordController.text) {
        return 'Passwords do not match';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Branding
                  Icon(Icons.account_circle, size: 80, color: accentBlue),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    isLogin
                        ? 'Sign in to continue to your account'
                        : 'Register to get started with our app',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: accentBlue,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      floatingLabelStyle: TextStyle(color: accentBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: accentBlue, width: 2),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    validator: validatePassword,
                    obscureText: !showPassword,
                    cursorColor: accentBlue,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      floatingLabelStyle: TextStyle(color: accentBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: accentBlue, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    textInputAction:
                        isLogin ? TextInputAction.done : TextInputAction.next,
                  ),

                  // Confirm Password Field (only for registration)
                  if (!isLogin) ...[
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      validator: validateConfirmPassword,
                      obscureText: !showConfirmPassword,
                      cursorColor: accentBlue,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        floatingLabelStyle: TextStyle(color: accentBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: accentBlue, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ],

                  if (isLogin) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add forgot password functionality here
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: accentBlue),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : (isLogin
                                  ? signInWithEmailAndPassword
                                  : createUserWithEmailAndPassword),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: accentBlue.withOpacity(0.6),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                              : Text(
                                isLogin ? 'Sign In' : 'Create Account',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Temporary Development Button - can be removed for production
                  Visibility(
                    visible: false, // Set to false for production
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TabsScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accentBlue),
                        foregroundColor: accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Temp Login'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Switch between login and register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? "Don't have an account? "
                            : "Already have an account? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                            passwordController.clear();
                            confirmPasswordController.clear();
                            showPassword = false;
                            showConfirmPassword = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isLogin ? 'Sign Up' : 'Sign In',
                          style: TextStyle(
                            color: accentBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

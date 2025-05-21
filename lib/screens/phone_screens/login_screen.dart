import 'dart:developer';

import 'package:finance_track/providers/login_provider.dart';
import 'package:finance_track/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late WatchConnectivity _watchConnectivity;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _watchConnectivity = WatchConnectivity();

    _watchConnectivity.messageStream.listen((message) {
      log('[Watch] Message received: $message');
      if (message['UserSession'] == true) {
        _notifyWatchNotLoggedIn();
      }
    });
  }

  void _notifyWatchNotLoggedIn() async {
    try {
      if (await _watchConnectivity.isSupported &&
          await _watchConnectivity.isReachable) {
        await _watchConnectivity.sendMessage({'auth_message': 'Not Login'});
        log('Watch notified: Not logged in');
      } else {
        log('Watch not reachable or unsupported');
      }
    } catch (e) {
      log('WatchConnectivity error: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoggingIn = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    log('Attempting login for email: $email');

    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);

      setState(() => _isLoggingIn = false);

      if (user != null) {
        log('Firebase login success: UID=${user.uid}');

        final loginProvider = Provider.of<LoginProvider>(
          context,
          listen: false,
        );
        await loginProvider.login(email, password, _watchConnectivity);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign in successful!')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FinanceHomeScreen()),
        );
      } else {
        log('Firebase returned null user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      setState(() => _isLoggingIn = false);
      log('Exception during login: ${e.toString()}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF238BBE),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
             SizedBox(height: 40.h),
              Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
               Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLabel('Email'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'example@gmail.com',
                      validator: InputValidators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    _buildLabel('Password'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Enter your Password',
                      validator: InputValidators.validatePassword,
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[700],
                        ),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child:  Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
                 SizedBox(height: 8.h),
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isLoggingIn ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D3343),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        _isLoggingIn
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            :  Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp,

                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              SizedBox(height: 30.h),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white70)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('X', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(child: Divider(color: Colors.white70)),
                  ],
                ),
              SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

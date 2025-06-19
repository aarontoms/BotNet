import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:botnet/widgets/password_field.dart';
import 'package:botnet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final emailController = TextEditingController();
final usernameController = TextEditingController();
final passwordController = TextEditingController();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _loading = false;
  String? _message;

  void _signUp() async {
    final dio = Dio();
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _loading = true);

    try {
      final response = await dio.post(
        '$backendUrl/signup',
        data: {
          'email': email,
          'username': username,
          'password': password,
        },
      );

      setState(() {
        _loading = false;
        _message = 'Signup successful';
      });

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      final userDetails = response.data['userDetails'];

      final sharedPreferences = await SharedPreferences.getInstance();
      final secureStorage = FlutterSecureStorage();
      await sharedPreferences.setString('access_token', accessToken);
      await secureStorage.write(key: 'refresh_token', value: refreshToken);
      await sharedPreferences.setString('userDetails', jsonEncode(userDetails));

      Navigator.pushReplacementNamed(context, '/home');

    } on DioException catch (e) {
      String msg = 'Unknown error';
      e.response != null ? msg= e.response?.data : msg = "Network error. Try again later.";

      setState(() {
        _loading = false;
        _message = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10),
              PasswordField(
                label: "Password",
                controller: passwordController,
              ),
              SizedBox(height: 20),

              SizedBox(
                height:42,
                child: _loading ?
                  Center(child: CircularProgressIndicator()) :
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 42)),
                    child: Text('Sign Up'),
                  ),
              ),

              SizedBox(height: 10),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _message!,
                    style: TextStyle(color: _message!.contains('successful') ? Colors.green : Colors.red),
                  ),
                ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

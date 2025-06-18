import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:botnet/widgets/password_field.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:botnet/constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  String? _message;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    final dio = Dio();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _loading = true);

    try {
      print("here");
      final response = await dio.post(
        '$backendUrl/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      setState(() {
        _loading = false;
        _message = 'Login successful';
      });
      print("hello: ${response.data}");
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      final userDetails = response.data['userDetails'];

      final sharedPreferences = await SharedPreferences.getInstance();
      final secureStorage = FlutterSecureStorage();
      await sharedPreferences.setString('access_token', accessToken);
      await secureStorage.write(key: 'refresh_token', value: refreshToken);
      await sharedPreferences.setString('userDetails', jsonEncode(userDetails));
      // final acc = sharedPreferences.getString('access_token');
      // final ref = await secureStorage.read(key: 'refresh_token');

      Navigator.pushReplacementNamed(context, '/home');

    } on DioException catch (e) {
      String msg = 'Unknown error';
      e.response != null ? msg= e.response?.data : msg = "Network error. Try again later.";
      print(e.response);

      setState(() {
        _loading = false;
        _message = msg;
        // passwordController.clear();
        if (msg.contains("Username")) {
          usernameController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username')
              ),

              SizedBox(height: 10),

              PasswordField(
                controller: passwordController,
                label: "Password",
              ),

              SizedBox(height: 20),

              SizedBox(
                height: 42,
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 42)),
                        child: Text('Log in'),
                      ),
              ),


              SizedBox(height: 20),

              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _message!,
                    style: TextStyle(color: _message!.contains('successful') ? Colors.green : Colors.red),
                  ),
                ),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/forgot_password'),
                child: Text('Forgotten password?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),

              Spacer(),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No account? ', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: Text('Sign up', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      )
    );
  }
}
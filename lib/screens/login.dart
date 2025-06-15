import 'package:flutter/material.dart';
import '../widgets/password_field.dart';
import 'package:dio/dio.dart';

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
      final response = await dio.post(
        'https://99rkb3wb-3000.inc1.devtunnels.ms/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      setState(() {
        _loading = false;
        _message = 'Login successful';
      });

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

              if (_message != null) ...[
                Text(_message!, style: TextStyle(color: Colors.red, fontSize: 16)),
                SizedBox(height: 20),
              ],

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
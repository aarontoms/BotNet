import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                style: TextStyle(color: const Color(0xFFE0ECEC)), // Input text color
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  //floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                obscureText: true,
                style: TextStyle(color: const Color(0xFFE0ECEC)), // Input text color
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36), // Set minimumSize to occupy full width
                  ),
                  child: Text('Log in'),
                ),
              ),
              SizedBox(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text('No account? Sign up'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
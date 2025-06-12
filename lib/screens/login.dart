import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                // floatingLabelStyle for when the label moves up
                floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Input text color
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                // floatingLabelStyle for when the label moves up
                floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              obscureText: true,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Input text color
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Login logic
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text('No account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
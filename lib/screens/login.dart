import 'package:flutter/material.dart';
import '../widgets/password_field.dart';

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
              Spacer(),
              TextField(decoration: InputDecoration(labelText: 'Username')),

              SizedBox(height: 10),

              //TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              PasswordField(label: "Password",),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 36)),
                  child: Text('Log in'),
                ),
              ),

              SizedBox(height: 20),

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
              SizedBox(height: 15,)
            ],
          ),
        ),
      )
    );
  }
}
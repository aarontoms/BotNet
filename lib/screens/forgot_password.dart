import 'package:flutter/material.dart';

class Forgot extends StatelessWidget{
  const Forgot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  String username = '';

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const Center(
        child: Text('Profile Page'),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
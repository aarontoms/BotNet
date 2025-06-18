import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  String userDetails = '';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userDetails = prefs.getString('userDetails') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userDetails),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 32,),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/default_profile.png'),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jsonDecode(userDetails)['username'] ?? 'Username',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Posts'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('123', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Followers'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('456', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Following'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ]
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bio goes here...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 30),


            // Posts Section
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 50),
            const Text('No posts yet.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
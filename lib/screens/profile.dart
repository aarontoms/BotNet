import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants.dart';
import '../dio_interceptor.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserDetailsFromSharedPref().then((_) => fetchUserDetails());
  }

  Future<void> loadUserDetailsFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedDetails = prefs.getString('userDetails');
    if (loadedDetails != null) {
      setState(() {
        userDetails = jsonDecode(loadedDetails);
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserDetails() async {
    final response = await dio.get('$backendUrl/refreshDetails');
    final updatedDetails = response.data['userDetails'];

    final prefs = await SharedPreferences.getInstance();
    print('Type of updatedDetails: ${updatedDetails.runtimeType}');
    await prefs.setString('userDetails', jsonEncode(updatedDetails));
    print(response.data);

    setState(() {
      userDetails = updatedDetails;
    });

  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(userDetails['username'] ?? '??username??'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 32),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: InkWell(
                          onTap: () {
                              Navigator.pushNamed(context, '/camera');
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: userDetails['profilePicture'] == ''
                                    ? null
                                    : NetworkImage(userDetails['profilePicture']),
                                child: userDetails['profilePicture'] == ''
                                    ? const Icon(Icons.person, size: 100)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.add, size: 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userDetails['fullName'] ??
                                  'Full Name',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${(userDetails['posts'] as List?)?.length ?? ''}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text('Posts'),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${(userDetails['followers'] as List?)?.length ?? ''}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text('Followers'),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${(userDetails['following'] as List?)?.length ?? ''}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text('Following'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      userDetails['bio'] == ''
                          ? 'Bio goes here...'
                          : userDetails['bio'],
                      style: TextStyle(
                        fontSize: 16,
                        color: userDetails['bio'] == ''
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.pushNamed(context, '/edit_profile');
                            loadUserDetailsFromSharedPref();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF323232),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF323232),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Share Profile',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Postssss
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
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

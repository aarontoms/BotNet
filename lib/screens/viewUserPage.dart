import 'package:flutter/material.dart';
import 'package:botnet/widgets/bottomBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants.dart';
import '../dio_interceptor.dart';

class ViewUserPage extends StatefulWidget {
  final String username;

  const ViewUserPage({super.key, required this.username});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;
  bool isRequested = false;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final response = await dio.get(
      '$backendUrl/getUserDetails/${widget.username}',
    );
    final updatedDetails = response.data['userDetails'];
    // print("full user $updatedDetails");

    setState(() {
      userDetails = updatedDetails;
      isLoading = false;
    });
  }

  Future<void> handleFollowRequest() async {
    try {
      final response = await dio.post(
        '$backendUrl/sendFollowRequest/${widget.username}',
      );

      if (response.statusCode == 200) {
        setState(() {
          isRequested = true;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to follow user')));
      }
    } catch (e) {
      print('Error following user: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred')));
    }
  }

  Future<void> handleUnfollowRequest() async {
    try {
      final response = await dio.post(
        '$backendUrl/unfollowUser/${widget.username}',
      );

      if (response.statusCode == 200) {
        setState(() {
          userDetails['isFollowing'] = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to unfollow user')),
        );
      }
    } catch (e) {
      print('Error unfollowing user: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred')));
    }
  }

  Future<void> removeFollowRequest() async {
    try {
      final response = await dio.post(
        '$backendUrl/removeFollowRequest/${widget.username}',
      );

      if (response.statusCode == 200) {
        setState(() {
          isRequested = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove request')),
        );
      }
    } catch (e) {
      print('Error removing follow request: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    String username = userDetails['username'] ?? '';
    String fullName = userDetails['fullName'] ?? '';
    String bio = userDetails['bio'] ?? '';
    String profilePicture = userDetails['profilePicture'] ?? '';
    int postsCount =
        (userDetails['posts'] as List?)?.length ??
        userDetails['postsCount'] ??
        0;
    int followersCount =
        (userDetails['followers'] as List?)?.length ??
        userDetails['followersCount'] ??
        0;
    int followingCount =
        (userDetails['following'] as List?)?.length ??
        userDetails['followingCount'] ??
        0;
    bool isFollowing = userDetails['isFollowing'] ?? false;
    bool isRequested = userDetails['isRequested'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(username),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade800,
                              backgroundImage: profilePicture.isEmpty
                                  ? null
                                  : NetworkImage(profilePicture),
                              child: profilePicture.isEmpty
                                  ? const Icon(Icons.person, size: 100)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
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
                                        '$postsCount',
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
                                        '$followersCount',
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
                                        '$followingCount',
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
                      bio,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: isFollowing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final shouldUnfollow =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  'Unfollow User',
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to unfollow this user?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                    child: const Text(
                                                      'Unfollow',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                        if (shouldUnfollow == true) {
                                          handleUnfollowRequest();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF323232),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text("Unfollow"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/chat',
                                          arguments: widget.username,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF323232),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text("Message"),
                                    ),
                                  ),
                                ],
                              )
                            : isRequested
                            ? ElevatedButton(
                                onPressed: removeFollowRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF323232),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Requested",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: handleFollowRequest,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Follow"),
                              ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Postssss
            const Divider(thickness: 1),
            if (isFollowing) ...[
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}

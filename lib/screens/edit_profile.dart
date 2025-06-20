import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../dio_interceptor.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController phoneController;

  bool nameChanged = false;
  bool bioChanged = false;
  bool phoneChanged = false;

  Map<String, dynamic> userDetails = {};

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedDetails = prefs.getString('userDetails');
    if (loadedDetails != null) {
      final decoded = jsonDecode(loadedDetails);
      setState(() {
        userDetails = decoded;
        nameController = TextEditingController(text: decoded['fullName']);
        bioController = TextEditingController(text: decoded['bio']);
        phoneController = TextEditingController(text: decoded['phoneNumber']);
        nameController.addListener(() {
          setState(() {
            nameChanged = nameController.text != decoded['fullName'];
          });
        });
        bioController.addListener(() {
          setState(() {
            bioChanged = bioController.text != decoded['bio'];
          });
        });
        phoneController.addListener(() {
          setState(() {
            phoneChanged = phoneController.text != decoded['phoneNumber'];
          });
        });
      });
    }
  }

  Future<void> saveField(String field, String value) async {
    final response = await dio.post('$backendUrl/updateProfile', data: {
      field: value,
    });

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final updated = response.data['userDetails'];
      await prefs.setString('userDetails', jsonEncode(updated));
      setState(() {
        userDetails = updated;
        nameChanged = bioChanged = phoneChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userDetails.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {

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
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            if (nameChanged)
              TextButton(
                onPressed: () => saveField('fullName', nameController.text),
                child: const Text('Save Name'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            if (bioChanged)
              TextButton(
                onPressed: () => saveField('bio', bioController.text),
                child: const Text('Save Bio'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            if (phoneChanged)
              TextButton(
                onPressed: () => saveField('phoneNumber', phoneController.text),
                child: const Text('Save Phone Number'),
              ),
          ],
        ),
      ),
    );
  }
}
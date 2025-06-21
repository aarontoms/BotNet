import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? updatedImage;

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
        nameController = TextEditingController(text: userDetails['fullName']);
        bioController = TextEditingController(text: userDetails['bio']);
        phoneController = TextEditingController(
          text: userDetails['phoneNumber'],
        );
        nameController.addListener(() {
          setState(() {
            nameChanged = nameController.text != userDetails['fullName'];
          });
        });
        bioController.addListener(() {
          setState(() {
            bioChanged = bioController.text != userDetails['bio'];
          });
        });
        phoneController.addListener(() {
          setState(() {
            phoneChanged = phoneController.text != userDetails['phoneNumber'];
          });
        });
      });
    }
  }

  Future<void> saveField(String field, String value) async {
    try {
      final response = await dio.post(
        '$backendUrl/updateProfile',
        data: {field: value},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final updated = response.data['userDetails'];
        await prefs.setString('userDetails', jsonEncode(updated));
        setState(() {
          userDetails = updated;
          nameChanged = bioChanged = phoneChanged = false;
        });
      } else {
        print('Failed to save. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userDetails.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Take Photo'),
                            onTap: () async {
                              final result = await Navigator.pushNamed(context, '/camera');
                              if (result != null && result is String) {
                                File image = File(result);
                                setState(() {
                                  updatedImage = image;
                                });
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from Gallery'),
                            onTap: () async {
                              Navigator.pop(context);
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                File image = File(pickedFile.path);
                                setState(() {
                                  updatedImage = image;
                                });
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Remove Photo'),
                            onTap: () {
                              setState(() {
                                updatedImage = null;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: updatedImage != null
                            ? FileImage(updatedImage!)
                            : userDetails['profilePicture'] == ''
                            ? null
                            : NetworkImage(userDetails['profilePicture']),
                        child: updatedImage == null && userDetails['profilePicture'] == ''
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
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (updatedImage != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      setState(() {
                        updatedImage = null;
                      });
                    },
                    child: const Text('Undo'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () async {
                      final formData = FormData.fromMap({
                        'image': await MultipartFile.fromFile(updatedImage!.path, filename: updatedImage!.uri.pathSegments.last),
                      });
                      final response = await dio.post('$backendUrl/uploadProfilePicture', data: formData);

                      if (response.statusCode == 200) {
                        final prefs = await SharedPreferences.getInstance();
                        final updated = response.data['userDetails'];
                        await prefs.setString('userDetails', jsonEncode(updated));
                        setState(() {
                          userDetails = updated;
                          updatedImage = null;
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            if (nameChanged)
              TextButton(
                onPressed: () => saveField('fullName', nameController.text),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text('Save Phone Number'),
              ),
          ],
        ),
      ),
    );
  }
}

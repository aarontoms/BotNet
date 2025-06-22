import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../dio_interceptor.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  int cameraIndex = 1;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    await Permission.camera.request();
    cameras = await availableCameras();
    controller = CameraController(cameras![cameraIndex], ResolutionPreset.high);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      File galleryImage = File(picked.path);
      Navigator.pop(context, galleryImage.path);
    }
  }

  Future<void> captureImage() async {
    if (controller == null || !controller!.value.isInitialized) return;
    final cameraImage = await controller!.takePicture();
    Navigator.pop(context, cameraImage.path);
  }

  void switchCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    cameraIndex = cameraIndex == 0 ? 1 : 0;
    await controller?.dispose();
    controller = CameraController(cameras![cameraIndex], ResolutionPreset.high);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> uploadStoryImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      final response = await dio.post('$backendUrl/upload-story', data: formData);
      print('Upload success: ${response.data}');
    } catch (e) {
      print('Upload error: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: pickImageFromGallery,
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    iconSize: 36,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: captureImage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 56,
                      )
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: switchCamera,
                    icon: const Icon(Icons.flip_camera_android, color: Colors.white),
                    iconSize: 36,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

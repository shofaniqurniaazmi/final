import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/common/config/env.dart';
import 'package:nutritrack/presentation/pages/detail_kamera1.dart';
import 'package:nutritrack/presentation/widget/laoding_dialog.dart';
import 'package:nutritrack/service/firebase/storage_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? cameraController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<String> convertImageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<String?> _processImageWithGemini(XFile image) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKeyGemini,
    );

    try {
      var response = await model.generateContent({
        Content.multi([
          TextPart("Describe this image:"),
          if (image != null)
            DataPart("image/jpg", File(image.path).readAsBytesSync())
        ])
      });
      print('Gemini AI response: ${response.text}');
      return response.text;
    } catch (e) {
      print('Error processing image with Gemini: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await cameraController!.takePicture();
      setState(() {
        imagePath = picture.path;
      });
      print('Image path: $imagePath');
      try {
        LoadingDialog.showLoadingDialog(context, "Loading...");

        String? responseGemini = await _processImageWithGemini(picture);

        LoadingDialog.hideLoadingDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCamera1(imagePath: picture.path,responseGemini: responseGemini!,),
          ),
        );
      } catch (e) {
        print('Error uploading or processing image: $e');
        // Tampilkan pesan error ke pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $e')),
        );
      }
    } on CameraException catch (e) {
      print('Error taking picture: $e');
      // Tampilkan pesan error ke pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(cameraController!),
          ),
          if (imagePath != null)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(File(imagePath!)),
              ),
            ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

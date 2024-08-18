import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nutritrack/presentation/pages/detail_kamera1.dart';
import 'dart:io';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? cameraController;
  String? imagePath;

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController!.initialize();
      setState(() {});
    } on CameraException catch (e) {
      print('Error saat menginisialisasi kamera: $e');
    }
  }

  Future<void> _processImageWithGemini(String imagePath) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'Your_Api_Key',
    );

    final prompt = 'Analyze the nutritional content of the food in the image: $imagePath';
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);
      print('Hasil nutrisi: ${response.text}');
    } catch (e) {
      print('Error saat memproses gambar dengan Gemini: $e');
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

      // Memproses gambar menggunakan Gemini AI
      await _processImageWithGemini(picture.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCamera1(imagePath: picture.path),
        ),
      );
    } on CameraException catch (e) {
      print('Error saat mengambil gambar: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController?.dispose();
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

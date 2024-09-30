import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class FaceRegistration extends StatefulWidget {
  const FaceRegistration({Key? key}) : super(key: key);

  @override
  _FaceRegistrationState createState() => _FaceRegistrationState();
}

class _FaceRegistrationState extends State<FaceRegistration> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessingImage = false;
  String? _resultMessage = '';

  List<CameraDescription>? _cameras;
  CameraLensDirection _currentDirection = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _selectCamera(_currentDirection);
  }

  void _selectCamera(CameraLensDirection direction) async {
    final selectedCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == direction,
    );

    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _switchCamera() {
    setState(() {
      _currentDirection = _currentDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;
      _initializeCamera();
    });
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized || _isProcessingImage) return;

    setState(() {
      _isProcessingImage = true;
      _resultMessage = 'Processing image...';
    });

    try {
      final XFile picture = await _cameraController!.takePicture();

      await _detectFace(picture.path);

      // Upload the image and save attendance
      await _uploadImageToFirebase(picture.path);
    } catch (e) {
      setState(() {
        _resultMessage = 'Error taking picture: $e';
      });
    } finally {
      setState(() {
        _isProcessingImage = false;
      });
    }
  }

  Future<void> _detectFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      setState(() {
        _resultMessage = 'Face detected! Uploading...';
      });
    } else {
      setState(() {
        _resultMessage = 'No face detected. Please try again.';
      });
    }
  }

  Future<void> _uploadImageToFirebase(String imagePath) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child("face_images/${path.basename(imagePath)}");

    try {
      await imageRef.putFile(File(imagePath));

      final imageUrl = await imageRef.getDownloadURL();
      setState(() {
        _resultMessage = 'Image uploaded successfully';
      });
      print("Image URL: $imageUrl");

      // Save attendance to Firestore
      await _saveAttendance(imageUrl);
    } catch (e) {
      setState(() {
        _resultMessage = 'Failed to upload image: $e';
      });
    }
  }

  Future<void> _saveAttendance(String imageUrl) async {
    final attendanceCollection =
        FirebaseFirestore.instance.collection('attendance');

    // Create a new document with attendance data
    await attendanceCollection.add({
      'timestamp': FieldValue.serverTimestamp(), // Store current time
      'user_id': 'user_id_example', // Replace with the appropriate user ID
      'status': 'Present', // Replace with appropriate status
      'face_image_url': imageUrl, // The URL of the uploaded image
      'date': FieldValue.serverTimestamp(), // Timestamp for the date
    });

    // Kembali ke halaman AttendanceHistory setelah data berhasil disimpan
    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Wajah'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content
          children: [
            const SizedBox(height: 15),
            if (_isCameraInitialized)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  // Center the camera preview
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 450, // Set height as needed
                        width: 350, // Set width as needed
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 20),

            // Button to take photo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                // Center the button
                child: ElevatedButton.icon(
                  onPressed: _isProcessingImage ? null : _takePicture,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ambil Foto Wajah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Button to switch camera
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                // Center the button
                child: ElevatedButton.icon(
                  onPressed: _switchCamera,
                  icon: const Icon(Icons.switch_camera),
                  label: const Text('Ganti Kamera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Show result message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  _resultMessage ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:faceattend/auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay selama 3 detik sebelum pindah ke halaman login
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()), // Pastikan Login class sudah ada
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Background putih
      body: Center(
        child: Text(
          'FaceAttend',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Warna tulisan biru
          ),
        ),
      ),
    );
  }
}

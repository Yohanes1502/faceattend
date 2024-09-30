import 'package:faceattend/Attendance%20History/attendance_history.dart';
import 'package:faceattend/FaceRegis/face_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:faceattend/auth/login.dart';
import 'package:faceattend/splashScreen/SplashScreen.dart';
import 'package:faceattend/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FaceAttend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(), // Check if user is logged in
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const HomePage(),
        '/face_registration': (context) => const FaceRegistration(),
        '/attendance_history': (context) =>
            AttendanceHistory(), // Removed 'const'
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in or not
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If the user is logged in, navigate to HomePage
      return const HomePage();
    } else {
      // If the user is not logged in, navigate to Login page
      return const Login();
    }
  }
}

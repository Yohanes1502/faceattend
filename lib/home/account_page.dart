import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  // Function to log out the user
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding untuk jarak tepi
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          mainAxisAlignment: MainAxisAlignment.start, // Rata atas
          children: [
            // Menambahkan gambar di atas username
            Center(
              child: Image.asset(
                'assets/account.png', // Path gambar
                width: 100, // Lebar gambar
                height: 100, // Tinggi gambar
              ),
            ),
            const SizedBox(height: 20), // Jarak antara gambar dan username

            Text(
              'Username: ${user?.displayName ?? "Unknown"}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? "Unknown"}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  logout(context); // Log out the user
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

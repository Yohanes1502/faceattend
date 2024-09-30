import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentPageIndex == 2 // Jika halaman akun
          ? null // Sembunyikan AppBar
          : AppBar(
              title: const Text('FaceAttend'),
              backgroundColor: Colors.blue,
            ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person_add_alt),
            label: 'Pendaftaran Wajah',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Riwayat Absensi',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
      ),
      body: <Widget>[
        /// Halaman Pendaftaran Wajah
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tambahkan gambar di atas tombol "Daftar Wajah"
              Image.asset(
                'assets/faceNew.png',
                width: 200, // Atur lebar sesuai keinginan
                height: 200, // Atur tinggi sesuai keinginan
                fit: BoxFit.cover,
              ),
              const SizedBox(
                  height: 20), // Tambahkan jarak antara gambar dan tombol
              ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman Pendaftaran Wajah
                  Navigator.pushNamed(context, '/face_registration');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.black),
                child: const Text('Daftar Wajah'),
              ),
            ],
          ),
        ),

        /// Halaman Riwayat Absensi
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Riwayat Absensi'),
                  subtitle: Text('Ini adalah halaman riwayat absensi.'),
                ),
              ),
            ],
          ),
        ),

        /// Halaman Akun
        const AccountPage(), // Navigate to AccountPage widget here
      ][currentPageIndex],
    );
  }
}

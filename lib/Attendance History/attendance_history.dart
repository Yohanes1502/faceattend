import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faceattend/FaceRegis/face_registration.dart';
import 'package:flutter/material.dart';

class AttendanceHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('attendance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No attendance records found.'));
          }

          final attendanceRecords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = attendanceRecords[index];
              return ListTile(
                title: Text('User ID: ${record['user_id']}'),
                subtitle: Text('Status: ${record['status']}'),
                trailing: Image.network(record['face_image_url']),
              );
            },
          );
        },
      ),

      // Button to navigate to Face Registration
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FaceRegistration()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

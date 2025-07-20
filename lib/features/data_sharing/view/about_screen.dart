import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About This App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('LocalShare', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            Text('About This App', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('LocalShare allows you to quickly share text and files between devices on the same network using QR codes and direct connections.'),
            SizedBox(height: 24),
            Text('How to Use', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Open LocalShare on both devices.\n2. On the receiver, show your QR code from the home screen.\n3. On the sender, tap "Send Data" and scan the receiver QR.\n4. Enter your message or select a file, then tap send!'),
            SizedBox(height: 24),
            Text('Developed by Tejas Palyekar', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 
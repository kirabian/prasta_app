// lib/views/about_app_page.dart

import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan warna dari tema utama Anda
    final Color primaryColor = const Color(0xFF347338);
    final Color darkTextColor = const Color(0xFF2D3035);
    final Color backgroundColor = const Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Tentang Aplikasi",
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint, // Ganti dengan logo aplikasi Anda jika ada
              size: 80,
              color: primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              "Absensi Prasta",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Versi 1.0.0",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              "Aplikasi ini dirancang untuk memudahkan proses absensi karyawan secara efisien dan akurat menggunakan teknologi lokasi terkini. Dibuat dengan semangat untuk memberikan solusi terbaik bagi manajemen kehadiran.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const Spacer(),
            const Text(
              "Dibuat dengan Flutter ❤️",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

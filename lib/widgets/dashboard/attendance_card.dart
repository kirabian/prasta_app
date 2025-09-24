// lib/widgets/dashboard/attendance_card.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final Map<String, dynamic>? absenTodayData;

  const AttendanceCard({super.key, required this.absenTodayData});

  // Widget untuk menampilkan status Izin
  Widget _buildIzinStatus() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.white70, size: 36),
          SizedBox(height: 10),
          Text(
            "Anda tercatat Izin hari ini.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan Check-in & Check-out
  Widget _buildTimeStatus(String checkIn, String checkOut) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SlideInLeft(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 400),
          child: _buildTimeColumn("Check-in", checkIn, Icons.login),
        ),
        FadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 500),
          child: Container(
            width: 2,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        SlideInRight(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 400),
          child: _buildTimeColumn("Check-out", checkOut, Icons.logout),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Lokal
    const Color primaryColor = Color(0xFF1B3D25);
    const Color primaryLight = Color(0xFF2D5233);
    const Color accentColor = Color(0xFF3E6B42);

    // Ambil data dari map
    final checkIn = absenTodayData?['check_in'] ?? "--:--";
    final checkOut = absenTodayData?['check_out'] ?? "--:--";
    final apiStatus = absenTodayData?['status'] ?? "On Progress";

    // --- PERUBAHAN UTAMA DI SINI ---
    // Tentukan logika status dengan mengubah status dari API menjadi huruf kecil
    final bool isIzin = apiStatus.toString().toLowerCase() == 'izin';
    final bool isCompleted = checkIn != "--:--" && checkOut != "--:--";

    final String displayStatus;
    final Color statusColor;

    if (isIzin) {
      displayStatus = "Izin";
      statusColor = Colors.blueAccent; // Warna biru untuk status Izin
    } else {
      displayStatus = isCompleted ? "Completed" : "On Progress";
      statusColor = isCompleted ? Colors.greenAccent : Colors.orangeAccent;
    }
    // --- AKHIR PERUBAHAN ---

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryLight, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInLeft(
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  "Absensi Hari Ini",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              FadeInRight(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 300),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.7),
                    Colors.white.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Kondisi utama: tampilkan status izin ATAU waktu absen
          isIzin ? _buildIzinStatus() : _buildTimeStatus(checkIn, checkOut),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String title, String time, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// lib/widgets/map_check_in/reminders_card.dart

import 'package:flutter/material.dart';

class RemindersCard extends StatelessWidget {
  const RemindersCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color surfaceColor = Color(0xFF0D2818);
    const Color cardColor = Color(0xFF1B3D25);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                "Perhatikan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          const SizedBox(height: 16),
          _buildReminderRow(
            Icons.location_on_rounded,
            "Pastikan Anda berada di lokasi yang benar.",
          ),
          _buildReminderRow(
            Icons.phone_android_rounded,
            "Pastikan GPS dan koneksi internet Anda aktif.",
          ),
          _buildReminderRow(
            Icons.error_outline_rounded,
            "Segera laporkan jika terjadi kendala absensi.",
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

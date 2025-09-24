// lib/widgets/leave_request/leave_info_card.dart
import 'package:flutter/material.dart';

class LeaveInfoCard extends StatelessWidget {
  const LeaveInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF1B3D25);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Penting",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.schedule_rounded,
            "Izin hanya berlaku untuk hari ini",
          ),
          _buildInfoItem(
            Icons.warning_amber_rounded,
            "Pastikan alasan izin jelas dan valid",
          ),
          _buildInfoItem(
            Icons.send_rounded,
            "Pengajuan akan langsung dikirim ke sistem",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }
}
